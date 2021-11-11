import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/src/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/profile_page/add_user/add_user_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/profile_page/profile_page_header.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'logIn_activity/logInActivity.dart';

class ProfilePageRenewed extends StatefulWidget {
  @override
  _ProfilePageRenewedState createState() => _ProfilePageRenewedState();
}

class _ProfilePageRenewedState extends State<ProfilePageRenewed> {
  bool isNotificationToggled = false;
  bool isDarkThemeToggled = false;

  final log = Logger();

  Future<Map>example()async{
    var getBalance = await WsdlRequest().getTransactionSorted("ALL", "desc", "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
    Map mapValue = Map<String, dynamic>.from(getBalance);
    log.i(getBalance);
    Map? returnMap;
    return returnMap!;
  }
  onClickChangeEmail()async {
    var getBalance = await WsdlRequest().getAccountInfo("ALL", "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
      log.i(getBalance);
  }

  onClickChangePassword(){
    log.i("onClickChangePassword clicked");

  }
  onClickLogInActivity(){
    log.i("onClickLogInActivity clicked");
    Navigator.pushNamed(context, LogInActivity.routeName);
  }

  onClickAddUser(){
    log.i("onClickAddUser clicked");
    Navigator.pushNamed(context, AddUserScreen.routeName);
  }

  onClickUserList(){
    log.i("onClickUserList clicked");

  }

  onClickTurnOnNotifications(){
    log.i("onClickTurnOnNotifications clicked");

  }

  onClickChangeTheme(){
    log.i("onClickChangeTheme clicked");

  }

  onClickLogOut(){
    log.i("onClickLogOut clicked");

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }

  Column buildBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePageHeader(),
        SizedBox(height: 1.30.h),
        buildSettingsText(),
        buildSettingsList(),
        buildLogOut(),
      ],
    );
  }

  Padding buildSettingsText(){
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
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Padding buildSettingsList(){
    return Padding(
      padding: EdgeInsets.only(
        right: 5.55.w,
        left: 5.55.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEachRow("svg/envelope.svg", "E-posta değiştir", onClickChangeEmail, false, Container()),
          buildEachRow("svg/key.svg", "Şifre değiştir", onClickChangePassword, false,Container()),
          buildEachRow("svg/sign-in.svg", "Giriş etkinliği", onClickLogInActivity, false,Container()),
          buildEachRow("svg/user-add.svg", "Kullanıcı ekle", onClickAddUser, false,Container()),
          buildEachRow("svg/list_reverse.svg", "Kullanıcı Listesi", onClickUserList, false,Container()),
          buildEachRow("svg/envelope.svg", "Bildirimleri aç", onClickTurnOnNotifications, true, buildToggleBtnNotification()),
          buildEachRow("svg/moon.svg", "Koyu Tema", onClickChangeTheme, true, buildToggleBtnTheme()),
        ],
      ),
    );
  }

  Column buildEachRow(String logoName, String rowName, VoidCallback onTap, bool addToggle,Widget widget){
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 4.89.h,
            width: 88.80.w,
            decoration: BoxDecoration(
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 2.17.w,
                right: 2.17.w,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(logoName, color: AppColors.SignInColorGradientStart,),
                  SizedBox(width: 3.88.w,),
                  Text(
                      rowName,
                    style: TextStyle(
                      fontSize: LocalHelper.getFontSize(12),
                      color: AppColors.headerColor,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  Spacer(),
                  addToggle ? widget :
                  SvgPicture.asset("svg/arrow.svg", color: AppColors.textFormUnderLineColor,),
                ],
              ),
            ),
          ),
        ),
        Container(height: 0.65.h, color: AppColors.headerBelowColor.withOpacity(0.05),)
      ],
    );
  }

  FlutterSwitch buildToggleBtnNotification(){
    return FlutterSwitch(
      height: 3.26.h,
      width: 12.07.w,
      padding: 4.0,
      toggleSize: LocalHelper.getFontSize(15),
      borderRadius: 3,
      toggleColor: isNotificationToggled ? AppColors.SignInColorGradientStart: AppColors.textFormUnderLineColor,
      activeColor: AppColors.primaryWightColor,
      switchBorder: Border.all( color: isNotificationToggled ? AppColors.SignInColorGradientStart: AppColors.textFormUnderLineColor),
      inactiveColor: AppColors.primaryWightColor,
      value: isNotificationToggled,
      onToggle: (value) {
        setState(() {
          isNotificationToggled = value;
        });
      },
    );
  }

  FlutterSwitch buildToggleBtnTheme(){
    return FlutterSwitch(
      height: 3.26.h,
      width: 12.07.w,
      padding: 4.0,
      toggleSize: LocalHelper.getFontSize(15),
      borderRadius: 4,
      toggleColor: isDarkThemeToggled ? AppColors.SignInColorGradientStart: AppColors.textFormUnderLineColor,
      activeColor: AppColors.primaryWightColor,
      switchBorder: Border.all( color: isDarkThemeToggled ? AppColors.SignInColorGradientStart: AppColors.textFormUnderLineColor),
      inactiveColor: AppColors.primaryWightColor,
      value: isDarkThemeToggled,
      onToggle: (value) {
        setState(() {
          isDarkThemeToggled = value;
        });
      },
    );
  }

  Padding buildLogOut(){
    return Padding(
      padding: EdgeInsets.only(top: 1.98.h,
      right: 7.72.w,),
      child: Row(
        children: [
          Spacer(),
          InkWell(
            onTap: onClickLogOut,
            child: Container(
              width: 26.w,
              child: Row(
                children: [
                  SvgPicture.asset("svg/sign-out.svg", color: AppColors.icon_color,),
                  SizedBox(width: 3.14.w,),
                  Text("Çıkış yap",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(13),
                    color: AppColors.icon_color,
                    fontWeight: FontWeight.w600
                    ),
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
