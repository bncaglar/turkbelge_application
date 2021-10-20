import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class NavigatorButton extends StatefulWidget {
  final bool showLoading;
  final VoidCallback onTap;
  final String textLabel;

  NavigatorButton({
    required this.showLoading,
    required this.onTap,
    required this.textLabel
});
  @override
  _NavigatorButtonState createState() => _NavigatorButtonState();
}

class _NavigatorButtonState extends State<NavigatorButton> {

  @override
  Widget build(BuildContext context) {
    return buildSignInButton();
  }
  InkWell buildSignInButton() {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 7.06.h,
        width: 84.w,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.SignInColorGradientStart,
                  AppColors.SignInColorGradientEnd
                ])),
        child: Center(
          child: widget.showLoading
              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2, )
              : Text(
            widget.textLabel,
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(14),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
