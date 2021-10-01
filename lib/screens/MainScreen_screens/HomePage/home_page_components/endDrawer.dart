import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/home_page_components/add_new_bank.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class EndDrawerMainScreen extends StatefulWidget {
  const EndDrawerMainScreen({Key? key}) : super(key: key);

  @override
  _EndDrawerMainScreenState createState() => _EndDrawerMainScreenState();
}

class _EndDrawerMainScreenState extends State<EndDrawerMainScreen> {
  final log = getLogger();
  onClickAdd() {
    log.i("onClickAdd started");
    Navigator.pushNamed(context, AddNewBankPage.routeName);
  }

  onClickBankLogo() {
    log.i("onClickBankLogo started");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                addButton(),
                buildBankImagesColumn(),
                buildBankImagesColumn(),
                buildBankImagesColumn(),
                buildBankImagesColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container addButton() {
    return Container(
      height: 12.h,
      width: 20.w,
      child: IconButton(
        onPressed: onClickAdd,
        icon: Icon(
          Icons.add,
          color: AppColors.allNotificationsTextColor,
          size: LocalHelper.getFontSize(35),
        ),
      ),
    );
  }

  InkWell buildBankImagesColumn() {
    return InkWell(
      onTap: onClickBankLogo,
      child: Image.asset(
        Strings.akbank_square_logo,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
