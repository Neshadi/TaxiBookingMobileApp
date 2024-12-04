import 'package:flutter/material.dart';

import 'driver_screens/register_screen.dart';
import 'user_screens/register_screen.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key});

  @override
  Widget build(BuildContext context) {
    String description_1 =
        "Quick rides, greener journeys.Experience a smarter way to travel.Our app connects you with fast, reliable taxis for all your transportation needs.";

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Scaffold(
            backgroundColor: Colors.grey[850],
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Eco-Friendly ',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 15),
                      Image.asset(
                        "images/Ellipse 111.png",
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'TAXO*',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          description_1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'What type of user you are! ',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DriverRegisterScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(135, 50),
                          backgroundColor: Colors.amber.shade400,
                        ),
                        child: const Text(
                          'Driver',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(135, 50),
                          backgroundColor: Colors.amber.shade400,
                        ),
                        child: const Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
