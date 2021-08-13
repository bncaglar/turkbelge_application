import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        body: buildProfilePageBody(),
      ),
    );
  }

  InkWell buildProfilePageBody() {
    return InkWell(
      onTap: () {
        onClickLogOut();
      },
      child: Center(
        child: Container(
          height: 250,
          width: 250,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
