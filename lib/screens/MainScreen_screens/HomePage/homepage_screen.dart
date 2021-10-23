import 'package:flutter/material.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'home_page_components/bankListWithBalance.dart';
import 'home_page_components/homepage_background_color.dart';
import 'home_page_components/total_balance_container.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  final String getCurrency;
  final String customerNumber;
  final bool isUserAdmin;
  final String? subUserEmail;

  HomePage({
    required this.subUserEmail,
    required this.isUserAdmin,
    required this.getCurrency, required this.customerNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final log = getLogger();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

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
        TotalBalanceContainerOnHomePage(
          getCurrency: widget.getCurrency,
          subUserEmail: widget.subUserEmail,
          isUserAdmin: widget.isUserAdmin,
          customerNumber: widget.customerNumber,
        ),
        BankListWithBalance(),
      ],
    );
  }
}

class HomePageArguments {
  String getCurrency;
  String customerNumber;

  HomePageArguments({
    required this.customerNumber,
    required this.getCurrency,
  });
}
