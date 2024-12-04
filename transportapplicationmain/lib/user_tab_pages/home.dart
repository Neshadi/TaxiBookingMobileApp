import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../user_screens/trip_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool carSelected = false;
  bool vanSelected = false;
  bool cabSelected = false;
  bool lorrySelected = false;
  bool wheelSelected = false;
  bool bikeSelected = false;

  String selectedCategory = 'General';

  void _selectCategory(String category) {
    setState(() {
      carSelected = category == 'Car';
      vanSelected = category == 'Van';
      cabSelected = category == 'Cab';
      lorrySelected = category == 'Lorry';
      wheelSelected = category == 'Wheel';
      bikeSelected = category == 'Bike';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade400,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.amber.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('images/profileicon.jpg'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Good Morning ...',
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 21,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      'Enjoy With Your \n Booking',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryCard(
                        imagePath: 'images/TAXI.jpg',
                        label: 'Max 4 Seats',
                        selected: carSelected,
                        onTap: () => _selectCategory('Car'),
                      ),
                      CategoryCard(
                        imagePath: 'images/VAN.jpg',
                        label: 'Max 10 Seats',
                        selected: vanSelected,
                        onTap: () => _selectCategory('Van'),
                      ),
                      CategoryCard(
                        imagePath: 'images/CAB.jpg',
                        label: 'Max 5 Seats',
                        selected: cabSelected,
                        onTap: () => _selectCategory('Cab'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryCard(
                        imagePath: 'images/LORRY.jpg',
                        label: 'Max 2 Seats',
                        selected: lorrySelected,
                        onTap: () => _selectCategory('Lorry'),
                      ),
                      CategoryCard(
                        imagePath: 'images/WHEEL.jpg',
                        label: 'Max 3 Seats',
                        selected: wheelSelected,
                        onTap: () => _selectCategory('Wheel'),
                      ),
                      CategoryCard(
                        imagePath: 'images/MOTORBIKE.jpg',
                        label: 'Max 1 Seat',
                        selected: bikeSelected,
                        onTap: () => _selectCategory('Bike'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text("Where to your delivery?",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: selectedCategory);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            TripDetails(category: selectedCategory)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade400,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Take A Trip',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        color: selected
            ? Colors.blueAccent
            : const Color.fromRGBO(224, 224, 224, 1),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePath, height: 90, width: 90),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
