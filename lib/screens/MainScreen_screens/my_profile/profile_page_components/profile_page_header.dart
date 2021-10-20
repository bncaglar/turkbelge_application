import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';

import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ProfilePageHeader extends StatefulWidget {
  @override
  _ProfilePageHeaderState createState() => _ProfilePageHeaderState();
}

class _ProfilePageHeaderState extends State<ProfilePageHeader> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final log = Logger();

  onClickLogOut() async {
    log.i("OnClickLogOut Clicked!");
    await AuthenticationService(_firebaseAuth).logOut();
    Navigator.pushReplacementNamed(context, SignInPage.routeName);

    if (_firebaseAuth.currentUser == null) {

      ///todo log out successful
    } else {
      ///todo log out unsuccessful
    }
  }

  onClickSettings() async{
    log.i("onClickSettings Clicked!");

  }

  @override
  Widget build(BuildContext context) {
    return buildHeader();
  }

  Padding buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      child: Container(
        height: 20.h,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPlaceHolder(),
                buildUserText(),
                buildSettings(),
              ],
            ),
            buildCircleAvatar(),
            buildCompanyName(),
          ],
        ),
      ),
    );
  }

  Text buildUserText() {
    return Text(
      "KULLANICI",
      style: TextStyle(
        color: AppColors.primaryWightColor,
        fontSize: LocalHelper.getFontSize(15),
      ),
    );
  }

  Container buildPlaceHolder() {
    return Container(
      width: 13.w,
    );
  }

  Container buildSettings() {
    return Container(
      width: 13.w,
      child: IconButton(
        icon: Icon(
          Icons.settings,
          color: Colors.white,
          size: LocalHelper.getFontSize(20),
        ),
        onPressed: () {
          onClickSettings();
        },
      ),
    );
  }

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColors.primaryWightColor,
    );
  }

  Text buildCompanyName() {
    return Text(
      "İLEKA AKADEMİ A.S.",
      style: TextStyle(
        color: AppColors.primaryWightColor,
        fontSize: LocalHelper.getFontSize(15),
      ),
    );
  }
}
