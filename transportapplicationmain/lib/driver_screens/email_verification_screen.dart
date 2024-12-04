import 'vehicle_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: darkTheme ? Colors.black : Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'A verification email has been sent to your email address. Please check your inbox and click on the verification link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                  Fluttertoast.showToast(
                      msg:
                          "Verification email resent. Please check your email.");
                }
              },
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                await user?.reload();
                user = FirebaseAuth.instance.currentUser;
                if (user != null && user.emailVerified) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c) => const CarInfoScreen()));
                } else {
                  Fluttertoast.showToast(
                      msg: "Please verify your email first.");
                }
              },
              child: const Text('Continue Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
