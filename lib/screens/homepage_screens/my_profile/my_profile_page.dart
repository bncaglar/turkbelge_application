import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/services/randomCustomerNumberGenerator.dart';
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
    ///todo get user uid
    ///todo get user customer number via user uid
    ///todo generate random Password
    ///todo create subUser in authentication via email and password
    ///todo create subUser in fireStore
    ///todo send password via email
    ///todo log out
    ///todo WE MUST LOG USER IN RIGHT AFTER WE LOG OUT OF THE SUB USER
    String userCustomerNumber = await FireStoreService()
        .getCustomerNumber(_firebaseAuth.currentUser!.uid);
    print(userCustomerNumber);
    final password = generatePassword();
    print(_firebaseAuth.currentUser!.uid);
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: "example@gmail.com", password: password);
    User? user = _firebaseAuth.currentUser;
    await FireStoreService()
        .createSubUserInDB("_email", user!.uid, userCustomerNumber);
    print(user.uid);
    await FireStoreService()
        .sendRandomGeneratedPassword(password, "hv.plt.caglar@gmail.com");
    await _firebaseAuth.signOut();
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

  onClickCreateCustomerNumber() async {
    bool? isExist = false;
    var customerNumberGenerated;
    do{
    var list = await FireStoreService().getCollectionDocList("PreAppliedUsers");
    customerNumberGenerated = generateCustomerNumber();
    isExist = await FireStoreService()
        .checkCnForLogInActivity(customerNumberGenerated);
    }while(isExist!);


    print(customerNumberGenerated);
    print(isExist);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        appBar: buildAppBar(),
        body: Column(
          children: [
            buildProfilePageBody(),
            buildProfilePageasdBody(),
            buildProfilSDePageBody(),
          ],
        ),
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
          height: 100,
          color: Colors.red,
        ),
      ),
    );
  }

  Center buildProfilePageasdBody() {
    return Center(
      child: InkWell(
        onTap: onClickLogOut,
        child: Container(
          width: 150,
          height: 100,
          color: Colors.blue,
        ),
      ),
    );
  }

  Center buildProfilSDePageBody() {
    return Center(
      child: InkWell(
        onTap: onClickCreateCustomerNumber,
        child: Container(
          width: 150,
          height: 100,
          color: Colors.black,
        ),
      ),
    );
  }
}
