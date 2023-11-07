import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('3rd Tab',
            style: TextStyle(
                color: Colors.black
            )),
      ),
    );
  }
}