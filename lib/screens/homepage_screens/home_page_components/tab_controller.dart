import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/homepage_screens/homepage_screen.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class TabControllerPage extends StatefulWidget {
  static const routeName = '/TabController';

  @override
  _TabControllerPageState createState() => _TabControllerPageState();
}

class _TabControllerPageState extends State<TabControllerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.newColor4Background,
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 6.h,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Günaydın",
                      style: TextStyle(
                        fontSize: LocalHelper.getFontSize(16),
                        color: AppColors.homepageTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                TabBar(
                  labelColor: AppColors.primaryWightColor,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: AppColors.primaryWightColor,
                  tabs: [
                    Tab(text: "TRY"),
                    Tab(text: "USD"),
                    Tab(text: "EUR"),
                  ],
                ),
                Container(
                  height: 80.h,
                  child: TabBarView(
                    children: [
                      HomePage(),
                      HomePage(),
                      HomePage(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
