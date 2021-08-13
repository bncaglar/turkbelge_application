import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

import '../../signin_screen.dart';

class ForgetCustomerNumberVerifiedPage extends StatefulWidget {
  static const routeName = '/ForgetCustomerNumberVerifiedPage';
  final String? userEmail;

  ForgetCustomerNumberVerifiedPage({required this.userEmail});

  @override
  _ForgetCustomerNumberVerifiedPageState createState() =>
      _ForgetCustomerNumberVerifiedPageState();
}

class _ForgetCustomerNumberVerifiedPageState
    extends State<ForgetCustomerNumberVerifiedPage> {
  final log = getLogger();
  onClickLogIn() async {
    log.i("onClickLogIn started");
    Navigator.pushReplacementNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: AppColors.primaryGreyColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 7,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 80.h,
            width: 80.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(),
                  buildWelcomeText(),
                  SizedBox(
                    height: 8.h,
                  ),
                  buildVerifiedIcon(),
                  SizedBox(
                    height: 13.h,
                  ),
                  buildGoBackToLogInPage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 2.w, right: 2.w),
      child: Container(
        height: 10.h,
        width: 80.w,
        child: Center(
          child: Text(
            "Merhaba",
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(18),
              color: AppColors.backgroundPrimaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Container buildWelcomeText() {
    return Container(
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      height: 15.h,
      width: 80.w,
      child: Center(
        child: Text(
          "Müşteri numaranı başarılı bir şekilde " +
              widget.userEmail! +
              " adresine gönderdik",
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(12),
            color: AppColors.backgroundPrimaryColor,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container buildVerifiedIcon() {
    return Container(
      child: Icon(
        Icons.verified,
        color: Colors.green,
        size: LocalHelper.getFontSize(50),
      ),
    );
  }

  InkWell buildGoBackToLogInPage() {
    return InkWell(
      onTap: () {
        onClickLogIn();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.rememberMeBoxColor),
        height: 7.h,
        width: 35.w,
        child: Center(
          child: Text(
            "Giriş Ekranına Dön",
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(12),
              color: AppColors.dropDownMenuColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class ForgetCustomerNumberVerifiedPageArguments {
  String? userEmail;

  ForgetCustomerNumberVerifiedPageArguments({required this.userEmail});
}
