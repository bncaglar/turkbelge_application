import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/homepage_background_color.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/line_chart.dart';
import 'package:turkbelge_application/screens/homepage_screens/home_page_components/pie_chart.dart';
import 'package:turkbelge_application/screens/homepage_screens/homepage_screen.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class TabControllerPage extends StatefulWidget {
  static const routeName = '/TabController';

  @override
  _TabControllerPageState createState() => _TabControllerPageState();
}

class _TabControllerPageState extends State<TabControllerPage> {
  bool showOnChart = false;

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            if (showOnChart == true) {
                              setState(() {
                                showOnChart = false;
                              });
                            } else {
                              setState(() {
                                showOnChart = true;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 3.w),
                            width: 40.w,
                            child: showOnChart
                                ? Text(
                                    "Çizelgede gösterme",
                                    style: TextStyle(
                                      fontSize: LocalHelper.getFontSize(13),
                                      color: AppColors.homepageTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    "Çizelgede göster",
                                    style: TextStyle(
                                      fontSize: LocalHelper.getFontSize(13),
                                      color: AppColors.homepageTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Align(
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
                      Container(
                        width: 40.w,
                      )
                    ],
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
                showOnChart
                    ? Container(
                        height: 80.h,
                        child: TabBarView(
                          children: [
                            pieChartPageStack(),
                            pieChartPageStack(),
                            pieChartPageStack(),
                          ],
                        ))
                    : Container(
                        height: 80.h,
                        child: TabBarView(
                          children: [
                            HomePage(totalBalance: "15.945,00 TRY",),
                            HomePage(totalBalance: "3.458,00 \$",),
                            HomePage(totalBalance: "15.945,00 €",),
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

  Stack pieChartPageStack() {
    return Stack(
      children: [
        BackgroundColorOfHomePage(),
        Padding(
          padding: EdgeInsets.only(
            right: 7.w,
            top: 5.h,
            left: 7.w
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: PieChartSection(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 5.h
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: LineChartSample2(),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
