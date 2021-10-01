import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/settings_page/settings_page_components/add_user/add_user_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/settings_page/settings_page_components/log_activitiy/log_tab_controller.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/SettingsPage';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? notificationToggle = true;
  final user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final log = getLogger();

  onClickAddUser() {
    log.i("onClickAddUser started!");
    Navigator.pushNamed(context, AddUserPage.routeName);
  }

  onClickLogOut() async {
    await AuthenticationService(_firebaseAuth).logOut();
    if (_firebaseAuth.currentUser == null) {
      Navigator.pushReplacementNamed(context, SignInPage.routeName);

      ///todo log out successful
    } else {
      ///todo log out unsuccessful
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: AppColors.primaryWightColor,
        body: buildSettingsPage(),
      ),
    );
  }

  Padding buildSettingsPage() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSettingsPageBody(),
          buildIlekaEkstreVersion(),
        ],
      ),
    );
  }

  Column buildSettingsPageBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        buildAccountInfoText(),
        SizedBox(
          height: 5.h,
        ),
        buildCompanyEmailRow(),
        SizedBox(
          height: 4.h,
        ),
        buildPasswordRow(),
        SizedBox(
          height: 1.5.h,
        ),
        buildNotificationToggleRow(),
        SizedBox(
          height: 1.5.h,
        ),
        buildLogActivityRow(),
        SizedBox(
          height: 4.h,
        ),
        buildAddNewUserRow(),
        SizedBox(
          height: 10.h,
        ),
        buildLogOutButton(),
      ],
    );
  }

  Padding buildIlekaEkstreVersion() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Center(
        child: Text("İleka Ekstre 1.0.0",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor,
                fontSize: LocalHelper.getFontSize(14))),
      ),
    );
  }

  Row buildCompanyEmailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListText("E-posta"),
        Container(
          width: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(user!.email!,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor,
                      fontSize: LocalHelper.getFontSize(14))),
              Container(
                //height: _fontSizeHeight/45,
                width: 10.w,
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 17,
                    color: AppColors.backgroundPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row buildPasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListText("Şifre"),
        Container(
          width: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 10.w,
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 17,
                    color: AppColors.backgroundPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row buildNotificationToggleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListText("Bildirimleri aç"),
        Container(
          width: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildSwitch(),
            ],
          ),
        )
      ],
    );
  }

  Row buildLogActivityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListText("Giriş etkinliği"),
        Container(
          width: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 10.w,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, LogActivityTabController.routeName);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 17,
                    color: AppColors.backgroundPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row buildAddNewUserRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListText("Kullanıcı ekle"),
        Container(
          width: 10.w,
          child: InkWell(
            onTap: () {
              onClickAddUser();
            },
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 17,
              color: AppColors.backgroundPrimaryColor,
            ),
          ),
        )
      ],
    );
  }

  Align buildLogOutButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text(
                    "Çıkış yap",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: LocalHelper.getFontSize(14),
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  actions: [
                    Column(
                      children: [
                        Center(
                          child: Text(
                            "Çıkış yapmak istiyor musun?",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: LocalHelper.getFontSize(13),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text(
                                "Hayır",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: LocalHelper.getFontSize(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 18.18.w,
                            ),
                            TextButton(
                              child: Text(
                                "Evet",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: LocalHelper.getFontSize(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await onClickLogOut();
                                } catch (e) {
                                  print("error occured");
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                );
              });
        },
        child: Container(
          width: 30.25.w,
          height: 6.6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: AppColors.dismissRedColor,
          ),
          child: Center(
            child: Text(
              "Çıkış yap",
              style: TextStyle(
                color: AppColors.primaryWightColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildListText(String text) {
    return Container(
      width: 25.w,
      child: Text(
        text,
        style: TextStyle(
            fontSize: LocalHelper.getFontSize(14),
            fontWeight: FontWeight.w400,
            color: AppColors.backgroundPrimaryColor),
      ),
    );
  }

  Switch buildSwitch() {
    return Switch(
      onChanged: (v) {
        setState(() {
          notificationToggle = v;
        });
      },
      value: notificationToggle!,
    );
  }

  Text buildAccountInfoText() {
    return Text(
      "Profil bilgilerim",
      style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor,
          fontSize: LocalHelper.getFontSize(15)),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        child: Center(
            child: Text(
          "Ayarlar",
          style: TextStyle(color: AppColors.primaryWightColor, fontSize: 20),
        )),
        decoration: new BoxDecoration(
          color: AppColors.newColor4Background,
        ),
      ),
    );
  }
}
