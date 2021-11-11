import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/logic/account_sm/account_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/AccountBalance/account_balance_renewed.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/AccountBalance/account_balance_tabController.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/home_page_components/tab_controller.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/homepage.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/AllTransactionTabController.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/all_transaction_renewed.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/my_profile_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/profile_page/profile_page_renewed.dart';
import 'package:turkbelge_application/screens/noInternetConnectionPage.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class FirstNavigation extends StatefulWidget {
  static const routeName = '/FirstNavigation';
  final String customerNumber;
  final bool isUserAdmin;
  final String subUserEmail;
  FirstNavigation({
    required this.subUserEmail,
    required this.isUserAdmin,
    required this.customerNumber});

  @override
  _FirstNavigationState createState() => _FirstNavigationState();
}

class _FirstNavigationState extends State<FirstNavigation> {
  PageController _pagecontroller = PageController(initialPage: 0);
  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool?>(
        future: checkInternetConnection(),
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.data == false) {
            return NoInternetConnectionPage();
          } else {
            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pagecontroller,
              onPageChanged: (index) {
                setState(() {
                  selectedScreen = index;
                });
              },
              children: [
                HomePage(),
                AllTransactionRenewed(
                  addFilter: false,
                  birimTip: "",
                  islemTip: "",
                  maxAmount: 0,
                  addDateTimeFilter: false,
                  minAmount: 0,
                  numberOfFilter: 0,
                  bankCode: "ALL",
                  addHeader: true,
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                ),
                AccountBalanceScreenRenewed(),
                ProfilePageRenewed()
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 8.55.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.navigationBorderColor)
        ),
        child: BottomNavigationBar(
          currentIndex: selectedScreen,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "svg/home.svg",
                color: selectedScreen == 0
                    ? AppColors.SignInColorGradientStart
                    : AppColors.infoContentDialogColor,
              ),
              title: Text(
                "Anasayfa",
                style: TextStyle(
                  color: selectedScreen == 0
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(11),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  "svg/time-forward.svg",
                  color: selectedScreen == 1
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
              ),
              title: Text(
                "Hareketler",
                style: TextStyle(
                  color: selectedScreen == 1
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(11),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  "svg/bank.svg",
                  color: selectedScreen == 2
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
              ),
              title: Text(
                "Hesaplar",
                style: TextStyle(
                  color: selectedScreen == 2
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(11),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  "svg/user.svg",
                  color: selectedScreen == 3
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
              ),
              title: Text(
                "Hesabım",
                style: TextStyle(
                  color: selectedScreen == 3
                      ? AppColors.SignInColorGradientStart
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(11),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          onTap: (index) {
            if(index == 2){
              context.read<AccountAndTransactionCubit>().changState(AccountAndTransactionInitial());
            }
            _pagecontroller.jumpToPage(index);
          },
        ),
      ),
    );
  }

  Future<bool?> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

class FirstNavigationArguments {
  String? customerNumber;
  bool isUserAdmin;
  String subUserEmail;
  FirstNavigationArguments({
    required this.subUserEmail,
    required this.isUserAdmin,
    required this.customerNumber});
}
