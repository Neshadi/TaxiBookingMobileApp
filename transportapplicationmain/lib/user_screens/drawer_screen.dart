import 'package:flutter/material.dart';

import '../splash_screen/splash_screen.dart';
import '../user_global/global.dart';
import '../user_tab_pages/account.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 246, 190, 21),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userModelCurrentinfo?.name ?? 'Guest',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const UserProfilePage()));
                    },
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 226, 172, 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // const DrawerItem(title: "Your Trips"),
                  // const SizedBox(height: 15),
                  // const DrawerItem(title: "Payment"),
                  // const SizedBox(height: 15),
                  // const DrawerItem(title: "Notifications"),
                  // const SizedBox(height: 15),
                  // const DrawerItem(title: "Promos"),
                  // const SizedBox(height: 15),
                  // const DrawerItem(title: "Help"),
                  // const SizedBox(height: 15),
                  // const DrawerItem(title: "Free Trips"),
                ],
              ),
              GestureDetector(
                onTap: () {
                  firebaseAuth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SplashScreen()));
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;

  const DrawerItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
