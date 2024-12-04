import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../driver_global/global.dart';
import '../driver_models/ratings.dart';

class DriverRatingsPage extends StatefulWidget {
  const DriverRatingsPage({super.key});

  @override
  State<DriverRatingsPage> createState() => _DriverRatingsPageState();
}

class _DriverRatingsPageState extends State<DriverRatingsPage> {
  String driverId = firebaseAuth.currentUser!.uid;
  List<Ratings> ratingsList = [];

  void _getRatings(Function(List<Ratings>) onRatingsFetched) async {
    DatabaseReference ratingRef =
        FirebaseDatabase.instance.ref().child("driver_ratings");

    // Fetch the ratings data once
    ratingRef.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> ratingsMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        // Filter ratings by driverId
        ratingsMap.forEach((key, value) {
          if (key == driverId) {
            Ratings rating = Ratings.fromMap(value);
            ratingsList.add(rating);
          }
        });
      }
      // Pass the filtered list to the callback function
      onRatingsFetched(ratingsList);
    });
  }

  @override
  void initState() {
    super.initState();
    _getRatings((List<Ratings> ratings) {
      setState(() {
        ratingsList = ratings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text(
          "Driver Ratings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: darkTheme ? Colors.black : Colors.amber.shade400,
      ),
      body: ratingsList.isEmpty
          ? const Center(
              child: Text(
                "No ratings found",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          : ListView.builder(
              itemCount: ratingsList.length,
              itemBuilder: (context, index) {
                var rating = ratingsList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        rating.rating ?? "-",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('From: ${rating.pickUp ?? 'Unknown'}'),
                    subtitle: Text('To: ${rating.destination ?? 'Unknown'}'),
                    trailing: Text(
                      'Rating: ${rating.rating ?? 'N/A'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
