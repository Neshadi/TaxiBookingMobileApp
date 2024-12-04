import 'package:flutter/material.dart';

class NotificationsTabPage extends StatefulWidget {
  const NotificationsTabPage({super.key});

  @override
  State<NotificationsTabPage> createState() => _NotificationsTabPageState();
}

class _NotificationsTabPageState extends State<NotificationsTabPage> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        backgroundColor: darkTheme ? Colors.black : Colors.amber.shade400,
      ),
    );
  }
}
