import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
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
  final log = getLogger();
  bool showOnChart = false;

  onSettingsClicked() async {
    log.i("onSettingsClicked started");
  }

  showOnChartStateFunc() {
    log.i("showOnChartStateFunc started");
    if (showOnChart == true) {
      setState(() {
        showOnChart = false;
      });
    } else {
      setState(() {
        showOnChart = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.newColor4Background,
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 4.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: EdgeInsets.only(left: 3.w, top: 2.h),
                          width: 13.w,
                          child: showOnChart
                              ? IconButton(
                                  onPressed: showOnChartStateFunc,
                                  icon: Icon(
                                    Icons.multiline_chart,
                                    color: AppColors.primaryWightColor,
                                    size: 30,
                                  ),
                                )
                              : IconButton(
                                  onPressed: showOnChartStateFunc,
                                  icon: Icon(
                                    Icons.show_chart,
                                    color: AppColors.primaryWightColor,
                                    size: 30,
                                  ),
                                )),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(right: 3.w, top: 2.h),
                        child: Container(
                          width: 10.w,
                          child: IconButton(
                            onPressed: onSettingsClicked,
                            icon: Icon(
                              Icons.more_vert,
                              color: AppColors.primaryWightColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
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
                      height: 75.h,
                      child: TabBarView(
                        children: [
                          pieChartPageStack(),
                          pieChartPageStack(),
                          pieChartPageStack(),
                        ],
                      ))
                  : Container(
                      height: 75.h,
                      child: TabBarView(
                        children: [
                          HomePage(
                            totalBalance: "15.945,00 TRY",
                          ),
                          HomePage(
                            totalBalance: "3.458,00 \$",
                          ),
                          HomePage(
                            totalBalance: "15.945,00 €",
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  ///todo this will then seperate from this file.
  Stack pieChartPageStack() {
    return Stack(
      children: [
        BackgroundColorOfHomePage(),
        Padding(
          padding: EdgeInsets.only(right: 7.w, top: 5.h, left: 7.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: PieChartSection(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
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
