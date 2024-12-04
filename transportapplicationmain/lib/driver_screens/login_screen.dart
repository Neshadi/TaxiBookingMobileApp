import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../driver_assistants/assistant_methods.dart';
import '../driver_global/global.dart';
import '../splash_screen/splash_screen.dart';
import 'forgot_password_screen.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential auth =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        DatabaseReference driverRef =
            FirebaseDatabase.instance.ref().child("drivers");
        DataSnapshot snap = await driverRef
            .child(auth.user!.uid)
            .once()
            .then((value) => value.snapshot);

        if (snap.value != null) {
          currentUser = auth.user;
          await AssistantMethods.readCurrentOnlineUserInfo();
          await Fluttertoast.showToast(msg: "Successfully Logged In");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DriverMainScreen()));
        } else {
          await Fluttertoast.showToast(msg: "No record exist with this email");
          await FirebaseAuth.instance.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SplashScreen()));
        }
      } catch (error) {
        Fluttertoast.showToast(msg: "Error occurred: \n $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text(
            "Driver Login",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 5,
          centerTitle: true,
          backgroundColor: darkTheme ? Colors.grey[850] : Colors.amber.shade400,
          iconTheme: IconThemeData(
            color: darkTheme ? Colors.amber.shade400 : Colors.white,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme
                    ? "images/delivery.jpeg"
                    : "images/delivery.jpeg"),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailTextEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "e-mail",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: darkTheme
                                ? Colors.black45
                                : Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            prefixIcon: Icon(Icons.email,
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.grey),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Please enter an email";
                            }
                            if (!EmailValidator.validate(text)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordTextEditingController,
                          obscureText: !_passwordVisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: darkTheme
                                ? Colors.black45
                                : Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            prefixIcon: Icon(Icons.password,
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Please enter a password";
                            }
                            if (text.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                darkTheme ? Colors.grey : Colors.amber.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text("Login",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.amber.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Doesn't have an account?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const DriverRegisterScreen()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: darkTheme
                                      ? Colors.amber.shade400
                                      : Colors.amber.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
