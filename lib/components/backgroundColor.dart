import 'package:flutter/material.dart';

class BackgroundColor extends StatefulWidget {
  @override
  _BackgroundColorState createState() => _BackgroundColorState();
}

class _BackgroundColorState extends State<BackgroundColor> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBackgroundColor()
      ],
    );
  }
  Container buildBackgroundColor() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFADAF6F6),
            Color(0xFAE3FAFA),
            Color(0xFAF0FCFC),
            Color(0xFAF4FDFD),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    );
  }
}
