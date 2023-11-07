import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/button.dart';
import '../widget/textField.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final TextEditingController _firstNameController =
                  TextEditingController(text: snapshot.data!.get('firstName'));
              final TextEditingController _lastNameController =
                  TextEditingController(text: snapshot.data!.get('lastName'));
              final TextEditingController _emailController =
                  TextEditingController(text: snapshot.data!.get('email'));
              final TextEditingController _contactNumberController =
                  TextEditingController(
                      text: snapshot.data!.get('phoneNumber'));

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1511367461989-f85a21fda167?auto=format&fit=crop&q=80&w=1331&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyTextField(
                              title: "First Name",
                              hint: "",
                              controller: _firstNameController,
                            ),
                          ),
                          SizedBox(
                              width: 16), // Add some space between text fields
                          Expanded(
                            child: MyTextField(
                              title: "Last Name",
                              hint: "",
                              controller: _lastNameController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyTextField(
                      title: "Email",
                      hint: "",
                      controller: _emailController,
                    ),
                    MyTextField(
                      title: "Contact Number",
                      hint: "",
                      controller: _contactNumberController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            label: "Cancel",
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: MyButton(
                            label: "Save",
                            onTap: () {
                              //action
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
