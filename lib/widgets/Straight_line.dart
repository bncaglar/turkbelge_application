import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class StraightLine extends StatefulWidget {
  @override
  _StraightLineState createState() => _StraightLineState();
}

class _StraightLineState extends State<StraightLine> {
  @override
  Widget build(BuildContext context) {
    return buildStraightLine();
  }

  Container buildStraightLine() {
    return Container(
      height: 1,
      width: 88.40.w,
      color: AppColors.straightLineColor,
    );
  }
}
