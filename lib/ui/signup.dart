import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/homepage.dart';

import '../auth/authentication.dart';
import '../widget/input_field.dart';
import '../widget/passwordInput.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPassword = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align children to the start (left)
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Row with two text fields
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "",
                      hint: "First Name",
                      controller: _firstNameController,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "",
                      hint: "Last Name",
                      controller: _lastNameController,
                    ),
                  )
                ],
              ),
              InputField(
                  title: "", hint: "Email", controller: _emailController),
              InputField(
                  title: "",
                  hint: "Phone Number",
                  controller: _phoneNumberController),
              PasswordInput(
                  title: "", hint: "Password", controller: _passwordController),
              PasswordInput(
                  title: "",
                  hint: "Verify Password",
                  controller: _verifyPassword),
              SizedBox(height: 25.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                ),
                onPressed: () async {
                  // Check if passwords match
                  if (_passwordController.text != _verifyPassword.text) {
                    showSnackBar(context, 'Passwords do not match.');
                    return; // Exit the function early if passwords don't match
                  }
                  try {
                    final cred = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(cred.user!.uid)
                        .set({
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                      "email": _emailController.text,
                      "password": _passwordController.text,
                      "phoneNumber": _phoneNumberController.text,
                      "createdAt": DateTime.now(),
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                    print("successfully created!");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showSnackBar(context, 'Password is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      showSnackBar(context,
                          'The account already exists for that email.');
                    }
                  } catch (e) {
                    showSnackBar(context, "Something went wrong! Try again!");
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 25.0),
              Text.rich(
                TextSpan(
                  text: 'Already Have an Account? ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authentication()));
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey,
      content: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
