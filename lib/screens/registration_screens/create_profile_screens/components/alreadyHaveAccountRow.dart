import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';

class AlreadyHaveAccountRowCP extends StatefulWidget {
  final VoidCallback onClickLogIn;
  final String firstText;
  final String secondText;
  final double? bottomPadding;
  final double? paddingBetween;
  final double? topPadding;
  final double fontSize;
  AlreadyHaveAccountRowCP({
    required this.onClickLogIn,
    this.bottomPadding,
    this.paddingBetween,
    required this.firstText,
    required this.secondText,
    this.topPadding,
    required this.fontSize
  });

  @override
  _AlreadyHaveAccountRowCPState createState() =>
      _AlreadyHaveAccountRowCPState();
}

class _AlreadyHaveAccountRowCPState extends State<AlreadyHaveAccountRowCP> {
  @override
  Widget build(BuildContext context) {
    return buildAlreadyHaveAnAccountRow();
  }

  Padding buildAlreadyHaveAnAccountRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.topPadding ?? 0.h,
        bottom: widget.bottomPadding ?? 1.56.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.firstText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(widget.fontSize),
              color: const Color(0xffc3c3c3),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            width: widget.paddingBetween ?? 1.93.w,
          ),
          InkWell(
            onTap: widget.onClickLogIn,
            child: Text(
              widget.secondText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(widget.fontSize),
                color: const Color(0xffdb2820),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
