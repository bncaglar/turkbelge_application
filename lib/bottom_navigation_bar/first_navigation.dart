import 'dart:io';

import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/AccountBalance/account_balance_screen.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/AccountBalance/account_balance_tabController.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/home_page_components/tab_controller.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/AllTransactionTabController.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/my_profile_page.dart';
import 'package:turkbelge_application/screens/noInternetConnectionPage.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class FirstNavigation extends StatefulWidget {
  static const routeName = '/FirstNavigation';
  final String customerNumber;

  FirstNavigation({required this.customerNumber});

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
                HomePageTabControllerPage(
                  customerNumber: widget.customerNumber,
                ),
                AllTransactionTabController(),
                AccountBalanceTabController(),
                ProfilePage()
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedScreen,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: selectedScreen == 0
                  ? AppColors.newColor4Background
                  : AppColors.bottomNavigationBarColor,
            ),
            title: Text(
              "Anasayfa",
              style: TextStyle(
                color: selectedScreen == 0
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor,
                fontSize: LocalHelper.getFontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined,
                color: selectedScreen == 1
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor),
            title: Text(
              "Tüm Hareketler",
              style: TextStyle(
                color: selectedScreen == 1
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor,
                fontSize: LocalHelper.getFontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance,
                color: selectedScreen == 2
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor),
            title: Text(
              "Hesap Bakiye",
              style: TextStyle(
                color: selectedScreen == 2
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor,
                fontSize: LocalHelper.getFontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined,
                color: selectedScreen == 3
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor),
            title: Text(
              "Hesabım",
              style: TextStyle(
                color: selectedScreen == 3
                    ? AppColors.newColor4Background
                    : AppColors.bottomNavigationBarColor,
                fontSize: LocalHelper.getFontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
        onTap: (index) {
          _pagecontroller.jumpToPage(index);
        },
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

  FirstNavigationArguments({required this.customerNumber});
}
