import 'package:flutter/material.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

class NoInternetConnectionPage extends StatefulWidget {
  static const routeName = '/NoInternetConnectionPage';

  @override
  _NoInternetConnectionPageState createState() =>
      _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {
  final log = getLogger();

  onClickTryAgain() {
    log.i("onClickTryAgain started");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildNoConnectionPage(),
      ),
    );
  }

  Column buildNoConnectionPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            //height: 28.h,
            width: 30.w,
            child: Image.asset(
              Strings.no_wifi_png,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 5.h),
          child: Text(
            "İnternet bağlantını kontrol et",
            style: TextStyle(
                fontSize: LocalHelper.getFontSize(15),
                color: AppColors.modalBottomSheetColor,
                fontWeight: FontWeight.w300),
          ),
        ),
        buildLogInButton()
      ],
    );
  }

  NavigationButton buildLogInButton() {
    return NavigationButton(
      addBoxShape: true,
      navigationButtonText: "Tekrar Dene",
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickTryAgain,
      margin: EdgeInsets.only(
        left: 12.69.w,
        right: 12.69.w,
      ),
    );
  }
}
