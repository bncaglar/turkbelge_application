import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

import 'number_of_bank_and_account.dart';

class TotalBalanceContainerOnHomePage extends StatefulWidget {
  @override
  _TotalBalanceContainerOnHomePageState createState() =>
      _TotalBalanceContainerOnHomePageState();
}

class _TotalBalanceContainerOnHomePageState
    extends State<TotalBalanceContainerOnHomePage> {
  @override
  Widget build(BuildContext context) {
    return buildBalanceContainer();
  }

  Center buildBalanceContainer() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Container(
          height: 10.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: AppColors.homepageTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NumberOfBankAndAccount(),
              buildAccountTotalBalance(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildAccountTotalBalance() {
    return Container(
      width: 50.w,
      child: Center(
        child: Text(
          "15.945,00 TRY",

          ///todo we will get the balance info from api
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(15),
            color: Colors.green,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
