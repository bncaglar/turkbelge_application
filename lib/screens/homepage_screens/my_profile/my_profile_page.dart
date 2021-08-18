import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/services/randomPasswordGenerator.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final log = getLogger();
   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  oClickCreateUser() async {
    print(_firebaseAuth.currentUser!.uid);
    final password = generatePassword();
    await _firebaseAuth.createUserWithEmailAndPassword(email: "exddample@gmail.com", password: password);
    print(_firebaseAuth.currentUser!.uid);
   await FireStoreService().sendRandomGeneratedPassword(password, "hv.plt.caglar@gmail.com");
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
        onTap: oClickCreateUser,
        child: Container(
          width: 150,
          height: 200,
          color: Colors.red,
        ),
      ),
    );
  }

}
