import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import '../signin_screen.dart';

class AlreadyHaveAnAccountText extends StatefulWidget {
  final VoidCallback? onClickHighlightedText;
  final String? normalText;
  final String? highlightedText;

  AlreadyHaveAnAccountText(
      {required this.onClickHighlightedText,
      required this.highlightedText,
      required this.normalText});

  @override
  _AlreadyHaveAnAccountTextState createState() =>
      _AlreadyHaveAnAccountTextState();
}

class _AlreadyHaveAnAccountTextState extends State<AlreadyHaveAnAccountText> {
  final log = getLogger();

  onClickLogIn() {
    log.i("onClickLogIn started");
    Navigator.pushNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return buildAlreadyHaveAccount();
  }

  Padding buildAlreadyHaveAccount() {
    return Padding(
      padding: EdgeInsets.only(),
      child: Container(
        height: 6.h,
        width: double.infinity,
        child: Center(child: alreadyHaveAccountText()),
      ),
    );
  }

  RichText alreadyHaveAccountText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(14),
          color: AppColors.backgroundPrimaryColor,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: widget.normalText,
          ),
          TextSpan(
            text: widget.highlightedText,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.onClickHighlightedText!();
              },
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.newColor4Background),
          ),
        ],
      ),
    );
  }
}
