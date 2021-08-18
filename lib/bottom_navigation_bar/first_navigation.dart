import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/homepage_screens/account_balance_screen.dart';
import 'package:turkbelge_application/screens/homepage_screens/all_transactions/all_transactions_page.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/tab_controller.dart';
import 'package:turkbelge_application/screens/homepage_screens/my_profile/my_profile_page.dart';
import 'package:turkbelge_application/screens/noInternetConnectionPage.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class FirstNavigation extends StatefulWidget {
  static const routeName = '/FirstNavigation';

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
              controller: _pagecontroller,
              onPageChanged: (index) {
                setState(() {
                  selectedScreen = index;
                });
              },
              children: [
                TabControllerPage(),
                AllTransactionsPage(),
                AccountBalancePage(),
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
          _pagecontroller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
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
