import 'package:flutter/material.dart';
import 'package:turkbelge_application/screens/homepage_screens/bank_details/bank_details_page.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

import 'bank_details_accounts.dart';

class BankDetailsOfTabController extends StatefulWidget {
  static const routeName = '/BankDetailsOfTabController';
  final String? bankName;
  final String? bankAccountKey;
  final String? bankIcon;
  final BoxFit? fitt;
  BankDetailsOfTabController(
      {required this.bankAccountKey,
      required this.bankIcon,
      required this.bankName,
      required this.fitt});

  @override
  _BankDetailsOfTabControllerState createState() =>
      _BankDetailsOfTabControllerState();
}

class _BankDetailsOfTabControllerState
    extends State<BankDetailsOfTabController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homepageTextColor,
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 6.h,
              child: TabBar(
                labelColor: AppColors.backgroundPrimaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: AppColors.allNotificationsTextColor,
                tabs: [
                  Tab(text: "HESAPLAR"),
                  Tab(text: "HESAP HAREKETLERİ"),
                ],
              ),
            ),
            Container(
              height: 81.h,
              child: TabBarView(
                children: [BankAccountsSummary(), BankAccountsSummary()],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BankDetailsTabControllerArguments {
  String? bankName;
  String? bankIcon;
  String? bankAccountKey;
  BoxFit? fitt;
  BankDetailsTabControllerArguments(
      {required this.bankIcon,
      required this.bankName,
      required this.bankAccountKey,
      required this.fitt});
}
