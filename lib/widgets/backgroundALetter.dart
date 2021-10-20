import 'package:flutter/material.dart';
class BackgroundALetter extends StatefulWidget {
  @override
  _BackgroundALetterState createState() => _BackgroundALetterState();
}

class _BackgroundALetterState extends State<BackgroundALetter> {
  @override
  Widget build(BuildContext context) {
    return buildBackgroundALetter();
  }
  Container buildBackgroundALetter() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/A_letter.png'),
          fit: BoxFit.contain,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.03), BlendMode.dstIn),
        ),
      ),
    );
  }
}
