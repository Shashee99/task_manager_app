import 'package:flutter/material.dart';

class Alltab extends StatefulWidget {
  const Alltab({super.key});

  @override
  State<Alltab> createState() => _AlltabState();
}

class _AlltabState extends State<Alltab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Card(),
          ],
        ),
      ),
    );
  }
}
