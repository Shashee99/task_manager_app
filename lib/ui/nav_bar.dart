import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/export_import_page.dart';
import 'package:task_manager/ui/faq_page.dart';
import 'package:task_manager/ui/profile.dart';

import '../auth/authentication.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    snapshot.data!["firstName"] +
                        " " +
                        snapshot.data!["lastName"],
                  ),
                  accountEmail: Text(snapshot.data!["email"]),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?auto=format&fit=crop&q=80&w=1331&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://marketplace.canva.com/EAFB2eB7C3o/1/0/1600w/canva-yellow-and-turquoise-vintage-rainbow-desktop-wallpaper-Y4mYj0d-9S8.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Profile',
                  ),
                  onTap: () {
                    // Navigate to the Profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.import_export_rounded,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Export/Import Tasks',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExportImportPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.question_mark_rounded,
                    color: Colors.black,
                  ),
                  title: Text(
                    'FAQ',
                  ),
                  onTap: () {
                    // Navigate to the Profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FaqPage()),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     CupertinoIcons.info_circle,
                //     color: Colors.black,
                //   ),
                //   title: Text(
                //     'About',
                //   ),
                //   onTap: () {
                //     // Navigate to the Profile page
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => About()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.square_arrow_left,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Logout',
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then(
                      (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authentication(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
