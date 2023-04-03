import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  List<Color> color = [];
  BackgroundGradient({
    required this.color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: color,
          begin: Alignment.topCenter,
        ),
      ),
    );
  }
}
