import 'package:flutter/material.dart';

import '../ui/theme.dart';

class MyButton extends StatelessWidget {
  final Function onTap;
  final String label;

  MyButton({
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      onPressed: () {
        onTap();
      },
      child: Text(label,
        style: TextStyle(color: Colors.black),),
    );
  }
}
