import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingTab extends StatefulWidget {
  const PendingTab({super.key});

  @override
  State<PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('2nd Tab',
            style: TextStyle(
            color: Colors.black
        )),
      ),
    );
  }
}

