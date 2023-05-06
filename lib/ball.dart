import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double diam = 50;
    return Container(
      width: diam,
      height: diam,
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 172, 0, 9),
        shape: BoxShape.circle,
      ),
    );
  }
}