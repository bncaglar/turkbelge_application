import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

import '../signin_screen.dart';

class SecondStepOfRegistration extends StatefulWidget {
  static const routeName = '/SecondStepOfRegistration';
  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userCustomerNumber;
  final String? userTCKN;
  final String? userVKN;
  final String? userPhoneNumber;

  SecondStepOfRegistration({
    required this.userPassword,
    required this.userEmail,
    required this.userName,
    required this.userCustomerNumber,
    required this.userPhoneNumber,
    required this.userTCKN,
    required this.userVKN,
  });

  @override
  _SecondStepOfRegistrationState createState() =>
      _SecondStepOfRegistrationState();
}

class _SecondStepOfRegistrationState extends State<SecondStepOfRegistration> {
  final log = getLogger();
  TextEditingController codeSentController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    _firebaseAuth.signOut();
    super.initState();
  }

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
            "Merhaba " + widget.userName!,
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
          "Türkbelge ailesine hoşgeldin. Hesabını " +
              widget.userEmail! +
              " adresi üzerinden oluşturduk",
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

class SecondStepOfRegistrationArguments {
  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userCustomerNumber;
  final String? userTCKN;
  final String? userVKN;
  final String? userPhoneNumber;

  SecondStepOfRegistrationArguments({
    required this.userVKN,
    required this.userTCKN,
    required this.userPhoneNumber,
    required this.userCustomerNumber,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });
}
