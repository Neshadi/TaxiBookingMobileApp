import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/user_screens/login_screen.dart';

import '../user_global/global.dart';
import 'email_verification_screen.dart';
import 'social_login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await firebaseAuth
            .createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        )
            .then((auth) async {
          currentUser = auth.user;
          if (currentUser != null) {
            Map<String, String> userMap = {
              "id": currentUser!.uid,
              "name": nameTextEditingController.text.trim(),
              "email": emailTextEditingController.text.trim(),
              "phone": phoneTextEditingController.text.trim(),
            };
            DatabaseReference userRef =
                FirebaseDatabase.instance.ref().child("users");
            userRef.child(currentUser!.uid).set(userMap);

            // Send email verification
            await currentUser!.sendEmailVerification();

            Fluttertoast.showToast(
                msg:
                    "Successfully Registered. Please check your email to verify your account.");

            // Optional: Navigate to a screen that instructs the user to verify their email
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (c) => const EmailVerificationScreen()));
          }
        });
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
            "Customer Registration",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          elevation: 5,
          centerTitle: true,
          backgroundColor: darkTheme ? Colors.black : Colors.amber.shade400,
          iconTheme: IconThemeData(
            color: darkTheme ? Colors.amber.shade400 : Colors.black,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profileicon.jpg'),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Create your account",
                      style: TextStyle(
                          color: darkTheme
                              ? Colors.amber.shade400
                              : const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameTextEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 95, 90, 90)),
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
                            prefixIcon: Icon(Icons.person,
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailTextEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "e-mail",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 95, 90, 90)),
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
                          controller: phoneTextEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Phone",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 95, 90, 90)),
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
                            prefixIcon: Icon(Icons.phone,
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.grey),
                          ),
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
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 95, 90, 90)),
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
                                    : Color.fromARGB(255, 95, 90, 90),
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
                              backgroundColor: darkTheme
                                  ? Colors.grey
                                  : Colors.amber.shade400,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: _submit,
                            child: const Text("Register",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0)))),
                        const SizedBox(height: 5),
                        const SocialLogin(),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.amber.shade400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Have an account?",
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
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              child: Text(
                                "Sign In",
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
