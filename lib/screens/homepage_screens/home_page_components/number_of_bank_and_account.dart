import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class NumberOfBankAndAccount extends StatefulWidget {
  @override
  _NumberOfBankAndAccountState createState() => _NumberOfBankAndAccountState();
}

class _NumberOfBankAndAccountState extends State<NumberOfBankAndAccount> {
  @override
  Widget build(BuildContext context) {
    return buildNumberOfAccountColumn();
  }

  Container buildNumberOfAccountColumn() {
    return Container(
      padding: EdgeInsets.only(left: 5.w, top: 1.5.h, bottom: 1.5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildNumberOfBank(),
          buildNumberOfAccount(),
        ],
      ),
    );
  }

  Text buildNumberOfBank() {
    return Text(
      "5 Banka",
      style: TextStyle(
        fontSize: LocalHelper.getFontSize(12),
        color: AppColors.accountInfoColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text buildNumberOfAccount() {
    return Text(
      "8 Hesap",
      style: TextStyle(
        fontSize: LocalHelper.getFontSize(12),
        color: AppColors.accountInfoColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
