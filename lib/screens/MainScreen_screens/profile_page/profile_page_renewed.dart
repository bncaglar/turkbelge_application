import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/profile_page/change_email/change_email_screen.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/profile_page/profile_page_header.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/profile_page/change_password/enter_new_password_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/signInPages/SignInScreen_renewed.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'add_user/add_user_page.dart';
import 'logIn_activity/logInActivity.dart';

class ProfilePageRenewed extends StatefulWidget {
  final String customerNumber;
  final String email;
  final bool isUserAdmin;

  ProfilePageRenewed(
      {required this.customerNumber,
      required this.isUserAdmin,
      required this.email});

  @override
  _ProfilePageRenewedState createState() => _ProfilePageRenewedState();
}

class _ProfilePageRenewedState extends State<ProfilePageRenewed> {
  bool isNotificationToggled = false;
  bool isDarkThemeToggled = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final log = Logger();

  onClickChangeEmail() async {
    log.i("onClickChangeEmail clicked");
    Navigator.pushNamed(context, ChangeEmailScreen.routeName,
        arguments: ChangeEmailScreenArguments(
            customerNumber: widget.customerNumber,
            email: widget.email,
            isAdmin: widget.isUserAdmin));
  }

  onClickChangePassword() {
    log.i("onClickChangePassword clicked");
    Navigator.pushNamed(context, EnterNewPasswordScreen.routeName,
        arguments: EnterNewPasswordScreenArguments(
            customerNumber: widget.customerNumber,
            email: widget.email,
            isAdmin: widget.isUserAdmin));
  }

  onClickLogInActivity() {
    log.i("onClickLogInActivity clicked");
    Navigator.pushNamed(context, LogInActivity.routeName);
  }

  onClickAddUser() {
    log.i("onClickAddUser clicked");
    Navigator.pushNamed(context, AddUserScreen.routeName);
  }

  onClickUserList() {
    log.i("onClickUserList clicked");
    log.wtf(_firebaseAuth);
  }

  onClickTurnOnNotifications() {
    log.i("onClickTurnOnNotifications clicked");
  }

  onClickChangeTheme() {
    log.i("onClickChangeTheme clicked");
  }

  onClickLogOut() async {
    log.i("onClickLogOut clicked");
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                  height: 25.h,
                  width: 90.w,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 2.h, right: 2.5.w, left: 2.5.w, bottom: 2.h),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Çıkış yap",
                          style: TextStyle(
                              color: AppColors.icon_color,
                              fontSize: LocalHelper.getFontSize(18),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "Çıkış yapmak istediğine emin misin?",
                          style: TextStyle(
                              color: AppColors.infoContentDialogColor,
                              fontSize: LocalHelper.getFontSize(14),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 5.70.h,
                                width: 32.71.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.boxColor),
                                ),
                                child: Center(
                                    child: Text(
                                  "İptal",
                                  style: TextStyle(
                                      color: AppColors.SignInColorGradientStart,
                                      fontSize: LocalHelper.getFontSize(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 2.17.w,
                            ),
                            InkWell(
                              onTap: () async {
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                await _auth.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPageRenewed(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 5.70.h,
                                width: 32.71.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.SignInColorGradientStart,
                                      AppColors.SignInColorGradientEnd
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Çıkış yap",
                                  style: TextStyle(
                                      color: AppColors.primaryWightColor,
                                      fontSize: LocalHelper.getFontSize(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePageHeader(
          customerNumber: widget.customerNumber,
          email: "hv.plt.caglar@gmail.com",
        ),
        SizedBox(height: 1.30.h),
        buildMiddleColumn(),
      ],
    );
  }

  Column buildMiddleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSettingsText(),
        buildSettingsList(),
        buildLogOut(),
      ],
    );
  }

  Padding buildSettingsText() {
    return Padding(
      padding: EdgeInsets.only(
        left: 7.72.w,
        bottom: 1.50.h,
      ),
      child: Text(
        "Ayarlar",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(17),
            color: AppColors.filterAgainTextColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding buildSettingsList() {
    return Padding(
      padding: EdgeInsets.only(
        right: 5.55.w,
        left: 5.55.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEachRow("svg/envelope.svg", "E-posta değiştir",
              onClickChangeEmail, false, Container()),
          buildEachRow("svg/key.svg", "Şifre değiştir", onClickChangePassword,
              false, Container()),
          buildEachRow("svg/sign-in.svg", "Giriş etkinliği",
              onClickLogInActivity, false, Container()),
          widget.isUserAdmin
              ? buildEachRow("svg/user-add.svg", "Kullanıcı ekle",
                  onClickAddUser, false, Container())
              : Container(),
          widget.isUserAdmin
              ? buildEachRow("svg/list_reverse.svg", "Kullanıcı Listesi",
                  onClickUserList, false, Container())
              : Container(),
          buildEachRow("svg/envelope.svg", "Bildirimleri aç",
              onClickTurnOnNotifications, true, buildToggleBtnNotification()),
          buildEachRow("svg/moon.svg", "Koyu Tema", onClickChangeTheme, true,
              buildToggleBtnTheme()),
          widget.isUserAdmin
              ? Container()
              : Container(
                  height: 9.78.h,
                ),
        ],
      ),
    );
  }

  Column buildEachRow(String logoName, String rowName, VoidCallback onTap,
      bool addToggle, Widget widget) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 4.89.h,
            width: 88.80.w,
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsets.only(
                left: 2.17.w,
                right: 2.17.w,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    logoName,
                    color: AppColors.SignInColorGradientStart,
                  ),
                  SizedBox(
                    width: 3.88.w,
                  ),
                  Text(
                    rowName,
                    style: TextStyle(
                        fontSize: LocalHelper.getFontSize(12),
                        color: AppColors.headerColor,
                        fontFamily: 'Poppins'),
                  ),
                  Spacer(),
                  addToggle
                      ? widget
                      : SvgPicture.asset(
                          "svg/arrow.svg",
                          color: AppColors.textFormUnderLineColor,
                        ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 0.65.h,
          color: AppColors.headerBelowColor.withOpacity(0.05),
        )
      ],
    );
  }

  FlutterSwitch buildToggleBtnNotification() {
    return FlutterSwitch(
      height: 3.26.h,
      width: 12.07.w,
      padding: 4.0,
      toggleSize: LocalHelper.getFontSize(15),
      borderRadius: 3,
      toggleColor: isNotificationToggled
          ? AppColors.SignInColorGradientStart
          : AppColors.textFormUnderLineColor,
      activeColor: AppColors.primaryWightColor,
      switchBorder: Border.all(
          color: isNotificationToggled
              ? AppColors.SignInColorGradientStart
              : AppColors.textFormUnderLineColor),
      inactiveColor: AppColors.primaryWightColor,
      value: isNotificationToggled,
      onToggle: (value) {
        setState(() {
          isNotificationToggled = value;
        });
      },
    );
  }

  FlutterSwitch buildToggleBtnTheme() {
    return FlutterSwitch(
      height: 3.26.h,
      width: 12.07.w,
      padding: 4.0,
      toggleSize: LocalHelper.getFontSize(15),
      borderRadius: 4,
      toggleColor: isDarkThemeToggled
          ? AppColors.SignInColorGradientStart
          : AppColors.textFormUnderLineColor,
      activeColor: AppColors.primaryWightColor,
      switchBorder: Border.all(
          color: isDarkThemeToggled
              ? AppColors.SignInColorGradientStart
              : AppColors.textFormUnderLineColor),
      inactiveColor: AppColors.primaryWightColor,
      value: isDarkThemeToggled,
      onToggle: (value) {
        setState(() {
          isDarkThemeToggled = value;
        });
      },
    );
  }

  Padding buildLogOut() {
    return Padding(
      padding: EdgeInsets.only(
        top: 1.98.h,
        right: 7.72.w,
      ),
      child: Row(
        children: [
          Spacer(),
          InkWell(
            onTap: onClickLogOut,
            child: Container(
              width: 26.w,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "svg/sign-out.svg",
                    color: AppColors.icon_color,
                  ),
                  SizedBox(
                    width: 3.14.w,
                  ),
                  Text(
                    "Çıkış yap",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(13),
                        color: AppColors.icon_color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
