import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/bankListWithBalance.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/homepage_background_color.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/total_balance_container.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  final String? totalBalance;
  HomePage({required this.totalBalance});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
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
        backgroundColor: AppColors.newColor4Background,
        body: Stack(
          children: [
            BackgroundColorOfHomePage(),
            buildHomePageBody(),
          ],
        ),
      ),
    );
  }

  Column buildHomePageBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TotalBalanceContainerOnHomePage(totalBalance: widget.totalBalance!,),
        BankListWithBalance(),
      ],
    );
  }
}
