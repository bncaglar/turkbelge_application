import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class BackgroundColorOfHomePage extends StatefulWidget {
  @override
  _BackgroundColorOfHomePageState createState() =>
      _BackgroundColorOfHomePageState();
}

class _BackgroundColorOfHomePageState extends State<BackgroundColorOfHomePage> {
  @override
  Widget build(BuildContext context) {
    return buildBackgroundColor();
  }

  Column buildBackgroundColor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 75.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              color: AppColors.primaryWightColor),
        )
      ],
    );
  }
}
