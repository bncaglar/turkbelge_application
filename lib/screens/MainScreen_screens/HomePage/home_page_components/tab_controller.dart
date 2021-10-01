import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/home_page_components/pie_chart.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/home_page_components/endDrawer.dart';
import '../homepage_screen.dart';
import 'homepage_background_color.dart';
import 'line_chart.dart';

class HomePageTabControllerPage extends StatefulWidget {
  static const routeName = '/TabController';
  final String customerNumber;
  HomePageTabControllerPage({required this.customerNumber});

  @override
  _HomePageTabControllerPageState createState() => _HomePageTabControllerPageState();
}

class _HomePageTabControllerPageState extends State<HomePageTabControllerPage> {
  final log = getLogger();
  bool showOnChart = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  onSettingsClicked() async {
    log.i("onSettingsClicked started");
    _scaffoldkey.currentState!.openEndDrawer();
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
        key: _scaffoldkey,
        endDrawer: EndDrawerMainScreen(),
        backgroundColor: AppColors.newColor4Background,
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildGoodMorningMessages(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildChangeTheChartIcon(),
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
                  buildSettingsVert()
                ],
              ),
              showOnChart
                  ? Container(
                      height: 74.h,
                      child: TabBarView(
                        children: [
                          pieChartPageStack(),
                          pieChartPageStack(),
                          pieChartPageStack(),
                        ],
                      ),
                    )
                  : Container(
                      height: 74.h,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          HomePage(
                            customerNumber: widget.customerNumber,
                            getCurrency: "TRY",
                          ),
                          HomePage(
                            customerNumber: widget.customerNumber,
                            getCurrency: "USD",
                          ),
                          HomePage(
                            customerNumber: widget.customerNumber,
                            getCurrency: "EUR",
                          ),
                        ],
                      ),
                    ),
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

  Container buildGoodMorningMessages() {
    return Container(
      width: double.infinity,
      height: 5.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }

  Container buildChangeTheChartIcon() {
    return Container(
      padding: EdgeInsets.only(left: 3.w),
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
            ),
    );
  }

  Padding buildSettingsVert() {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
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
    );
  }
}
