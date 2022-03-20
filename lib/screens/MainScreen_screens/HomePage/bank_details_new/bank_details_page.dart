import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/src/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/all_transaction_renewed.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'bank_details_accounts.dart';

class BankDetailsNew extends StatefulWidget {
  static const routeName = '/BankDetailsNew';
  final String bankCode;
  final String customerNumber;

  bool navigateFromAcc;

  BankDetailsNew({required this.bankCode, required this.navigateFromAcc, required this.customerNumber});

  @override
  _BankDetailsNewState createState() => _BankDetailsNewState();
}

class _BankDetailsNewState extends State<BankDetailsNew> {
  String onSelected = "Hesaplar";
  TextEditingController searchController = TextEditingController();

  onClickBackBtn() {
    Get.back();
    context
        .read<AccountAndTransactionCubit>()
        .changState(AccountAndTransactionInitial());
  }

  onClickAccounts() {
    setState(() {
      onSelected = "Hesaplar";
    });
  }

  onClickTransactions() {
    setState(() {
      onSelected = "Hareketler";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: buildBodyColumn(),
        ),
        Flexible(
          flex: 12,
          child: returnTabController(),
        ),
      ],
    );
  }

  SingleChildScrollView buildBodyColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderOfDetails(),
          buildController(),
        ],
      ),
    );
  }

  Row buildHeaderOfDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBackBtn(),
      ],
    );
  }

  Padding buildBackBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 3.39.h, left: 7.72.w, bottom: 1.70.h),
      child: InkWell(
        onTap: onClickBackBtn,
        child: SvgPicture.asset(
          "svg/backBtn.svg",
          color: AppColors.textFormUnderLineColor,
        ),
      ),
    );
  }

  Row buildController() {
    return Row(
      children: [
        buildAccountController(),
        buildTransactionsController(),
      ],
    );
  }

  InkWell buildAccountController() {
    return InkWell(
      onTap: onClickAccounts,
      child: Container(
        width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hesaplar",
              style: TextStyle(
                  color: onSelected == "Hesaplar"
                      ? AppColors.filterAgainTextColor
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight: onSelected == "Hesaplar"
                      ? FontWeight.w600
                      : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "Hesaplar"
                ? buildIndicatorLine()
                : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  InkWell buildTransactionsController() {
    return InkWell(
      onTap: onClickTransactions,
      child: Container(
        width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hesap Hareketleri",
              style: TextStyle(
                  color: onSelected == "Hareketler"
                      ? AppColors.filterAgainTextColor
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight: onSelected == "Hareketler"
                      ? FontWeight.w600
                      : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "Hareketler"
                ? buildIndicatorLine()
                : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  Container buildIndicatorLine() {
    return Container(
      height: 1,
      width: 50.w,
      color: AppColors.SignInColorGradientStart,
    );
  }

  Container buildNonIndicatorLine() {
    return Container(
      height: 1,
      width: 50.w,
      color: AppColors.textFormUnderLineColor,
    );
  }

  Widget returnTabController() {
    if (onSelected == "Hesaplar") {
      return BankDetailsAllAccounts(
        getBankCode: widget.bankCode,
      );
    } else if (onSelected == "Hareketler") {
      return AllTransactionRenewed(
        addHeader: false,
        minAmount: 0,
        maxAmount: 0,
        addFilter: false,
        birimTip: "",
        islemTip: "",
        addDateTimeFilter: false,
        customerNumber: widget.customerNumber,
        numberOfFilter: 0,
        bankCode: widget.bankCode,
        endDate: DateTime.now(),
        startDate: DateTime.now(),
      );
    }
    return Container();
  }
}

class BankDetailsNewArguments {
  final String bankCode;
  bool navigateFromAcc;
  final String customerNumber;

  BankDetailsNewArguments(
      {required this.bankCode, required this.navigateFromAcc, required this.customerNumber});
}
