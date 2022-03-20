import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class LogInActivityBackBtn extends StatefulWidget {
  @override
  _LogInActivityBackBtnState createState() => _LogInActivityBackBtnState();
}

class _LogInActivityBackBtnState extends State<LogInActivityBackBtn> {
  onClickBackBtn() {
    Get.back();
  }
  @override
  Widget build(BuildContext context) {
    return buildBackBtn();
  }
  Padding buildBackBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: 3.39.h,
          left: 7.72.w,
          bottom: 1.70.h
      ),
      child: InkWell(
        onTap: onClickBackBtn,
        child: SvgPicture.asset(
          "svg/backBtn.svg",
          color: AppColors.textFormUnderLineColor,
        ),
      ),
    );
  }
}
