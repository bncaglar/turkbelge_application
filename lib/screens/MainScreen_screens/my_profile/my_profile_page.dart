import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/profile_page_components/profile_page_company_info.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/profile_page_components/profile_page_header.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/services/generator/generate_sessionID.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final log = Logger();

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
    final password = generateSessionId();
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

  static int deger = 0;
  var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Body>
      <tem:GetTransaction>
         <!--Optional:-->
         <tem:transactionRequest>
            <!--Optional:-->
            <tem:SessionID>B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E</tem:SessionID>
            <!--Optional:-->
            <tem:StartDate>2021-06-20 15:00:00</tem:StartDate>
            <!--Optional:-->
            <tem:EndDate>2021-09-15 15:00:00</tem:EndDate>
            <!--Optional:-->
            <tem:BankCode>${deger}</tem:BankCode>
         </tem:transactionRequest>
      </tem:GetTransaction>
   </soapenv:Body>
</soapenv:Envelope>
''';
  final String apiEndpoint =
      "https://imza.turkbelge.com.tr/AccountTransaction.asmx?op=GetTransaction";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: [
            buildHeaderBackground(),
            Column(
              children: [ProfilePageHeader(), ProfilePageCompanyInfo(),],
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeaderBackground() {
    return Container(
      height: 30.h,
      width: double.infinity,
      color: AppColors.newColor4Background,
    );
  }



}
