import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/settings_page/settings_page_components/faulty_input_activity_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/my_profile/settings_page/settings_page_components/log_Activity_page.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/custom_app_bar.dart';

class LogActivityTabController extends StatefulWidget {
  static const routeName = '/LogActivityTabController';

  @override
  _LogActivityTabControllerState createState() =>
      _LogActivityTabControllerState();
}

class _LogActivityTabControllerState extends State<LogActivityTabController> {
  onClickBackBtn() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: AppColors.homepageTextColor,
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: SingleChildScrollView(
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
                      Tab(text: "Giriş Etkinliği"),
                      Tab(text: "Hatalı Girişler"),
                    ],
                  ),
                ),
                Container(
                  height: 83.h,
                  child: TabBarView(
                    children: [
                      LogActivityPage(),
                      FaultyInputActivityPage(),
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

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackBtn(),
          buildAppBarHeaderText(),
          Container(
            width: 15.w,
          ),
        ],
      ),
    );
  }

  Text buildAppBarHeaderText() {
    return Text(
      "Giriş Kayıtlarım",
      style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor,
          fontSize: LocalHelper.getFontSize(15)),
    );
  }

  Container buildBackBtn() {
    return Container(
      width: 15.w,
      child: IconButton(
        onPressed: () {
          onClickBackBtn();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.allNotificationsTextColor,
          size: 17.sp,
        ),
      ),
    );
  }
}
