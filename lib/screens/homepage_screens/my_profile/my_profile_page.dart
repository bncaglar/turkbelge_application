import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  onClickLogOut() async {
    await AuthenticationService(_firebaseAuth).logOut();
    if (_firebaseAuth.currentUser == null) {
      Navigator.pushReplacementNamed(context, SignInPage.routeName);
      log.i("Çıkış başarılı! :-)))");
    } else {
      log.i("Çıkış başarısız");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        appBar: buildAppBar(),
        body: buildProfilePageBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        child: Center(
            child: Text(
          "Hesabım",
          style: TextStyle(
              color: AppColors.backgroundPrimaryColor,
              fontSize: LocalHelper.getFontSize(15),
              fontWeight: FontWeight.w300),
        )),
        decoration: new BoxDecoration(
          color: AppColors.homepageTextColor,
        ),
      ),
    );
  }

  Center buildProfilePageBody() {
    return Center(
      child: InkWell(
        onTap: onClickLogOut,
        child: Container(
          width: 150,
          height: 200,
          color: Colors.red,
        ),
      ),
    );
  }

  Future<bool?> getSfData() async {
    SharedPreferences loginCheck = await SharedPreferences.getInstance();
    return loginCheck.getBool("state");
  }
}
