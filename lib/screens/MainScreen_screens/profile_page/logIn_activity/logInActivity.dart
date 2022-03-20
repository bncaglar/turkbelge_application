import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'log_in_activity_components/log_in_activity_proper.dart';

class LogInActivity extends StatefulWidget {
  static const routeName = '/LogInActivity';
  @override
  _LogInActivityState createState() => _LogInActivityState();
}

class _LogInActivityState extends State<LogInActivity> {
  String onSelected = "GirisEtkinligi";
  onClickBackBtn() {
    Get.back();
  }

  onClickLogInProper() {
    setState(() {
      onSelected = "GirisEtkinligi";
    });
  }

  onClickFaulty() {
    setState(() {
      onSelected = "HataliGirisler";
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(),
      ),
    );
  }
  Column buildBody() {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: buildBodyColumn(),
        ),
        Flexible(
          flex: 14,
          child: returnTabController(),
        ),
      ],
    );
  }

  Column buildBodyColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildBackBtn(),
        buildController(),
      ],
    );
  }

  Row buildController() {
    return Row(
      children: [
        buildAccountController(),
        buildTransactionsController(),
      ],
    );
  }

  InkWell buildAccountController() {
    return InkWell(
      onTap: onClickLogInProper,
      child: Container(
        width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Giriş Etkinliği",
              style: TextStyle(
                  color: onSelected == "GirisEtkinligi"
                      ? AppColors.filterAgainTextColor
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight: onSelected == "GirisEtkinligi"
                      ? FontWeight.w600
                      : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "GirisEtkinligi"
                ? buildIndicatorLine()
                : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  InkWell buildTransactionsController() {
    return InkWell(
      onTap: onClickFaulty,
      child: Container(
        width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hatalı Girişler",
              style: TextStyle(
                  color: onSelected == "HataliGirisler"
                      ? AppColors.filterAgainTextColor
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight: onSelected == "HataliGirisler"
                      ? FontWeight.w600
                      : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "HataliGirisler"
                ? buildIndicatorLine()
                : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  Row buildBackBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
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
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 3.39.h,
              bottom: 1.70.h
          ),
          child: Center(
            child: Text("Giriş Etkinliği",
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(15),
              fontFamily: 'Poppins',
              color: AppColors.headerColor,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 3.39.h,
              right: 7.72.w,
              bottom: 1.70.h
          ),
          child: SvgPicture.asset(
            "svg/backBtn.svg",
            color: AppColors.primaryWightColor,
          ),
        ),
      ],
    );
  }

  Container buildIndicatorLine() {
    return Container(
      height: 1,
      width: 50.w,
      color: AppColors.SignInColorGradientStart,
    );
  }

  Container buildNonIndicatorLine() {
    return Container(
      height: 1,
      width: 50.w,
      color: AppColors.textFormUnderLineColor,
    );
  }

  Widget returnTabController() {
    if(onSelected == "GirisEtkinligi"){
      return LogInActivityProper();
    }else if(onSelected == "HataliGirisler"){
      return Container();
    }
    return Container();
  }

}
