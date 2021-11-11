import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'account_balance_screen.dart';

class AccountBalanceScreenRenewed extends StatefulWidget {
  @override
  _AccountBalanceScreenRenewedState createState() =>
      _AccountBalanceScreenRenewedState();
}

class _AccountBalanceScreenRenewedState
    extends State<AccountBalanceScreenRenewed> {
  String onSelected = "TÜMÜ";

  onClickAll() {
    setState(() {
      onSelected = "TÜMÜ";
    });
  }

  onClickTRY() {
    setState(() {
      onSelected = "TRY";
    });
  }

  onClickUSD() {
    setState(() {
      onSelected = "USD";
    });
  }

  onClickEUR() {
    setState(() {
      onSelected = "EUR";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildCurrencyBloc(),
      ),
    );
  }

  BlocBuilder buildCurrencyBloc() {
    return BlocBuilder<AccountAndTransactionCubit, AccountAndTransactionState>(
        builder: (context, state) {
          if (state is AccountAndTransactionInitial) {
            return buildBodyWithFlexHeader();
          } else if (state is AccountAndTransactionEmit) {
            return buildBody();
          }
          return Container();
        });
  }

  Column buildBodyWithFlexHeader() {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: buildBodyColumn(),
        ),
        Flexible(
          flex: 11,
          child: returnCurrency(),
        ),
      ],
    );
  }

  Column buildBody() {
    return Column(
      children: [
        Flexible(
          flex: 11,
          child: returnCurrency(),
        ),
      ],
    );
  }

  Column buildBodyColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildHeaderText(),
        buildControllerTabRow(),
      ],
    );
  }

  Padding buildHeaderText() {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.98.h,
        bottom: 3.39.h,
      ),
      child: Text(
        "Hesap Bakiye",
        style: TextStyle(
            color: AppColors.headerColor,
            fontSize: LocalHelper.getFontSize(15),
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Row buildControllerTabRow() {
    return Row(
      children: [
        buildRowTitleAll(),
        buildRowTitleTRY(),
        buildRowTitleUSD(),
        buildRowTitleEUR()
      ],
    );
  }

  InkWell buildRowTitleAll() {
    return InkWell(
      onTap: onClickAll,
      child: Container(
        width: 25.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TÜMÜ",
              style: TextStyle(
                  color: onSelected == "TÜMÜ"
                      ? AppColors.icon_color
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight:
                      onSelected == "TÜMÜ" ? FontWeight.w600 : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "TÜMÜ"
                ? buildIndicatorLine()
                : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  InkWell buildRowTitleTRY() {
    return InkWell(
      onTap: onClickTRY,
      child: Container(
        width: 25.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TRY",
              style: TextStyle(
                  color: onSelected == "TRY"
                      ? AppColors.icon_color
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight:
                      onSelected == "TRY" ? FontWeight.w600 : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "TRY" ? buildIndicatorLine() : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  InkWell buildRowTitleUSD() {
    return InkWell(
      onTap: onClickUSD,
      child: Container(
        width: 25.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "USD",
              style: TextStyle(
                  color: onSelected == "USD"
                      ? AppColors.icon_color
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight:
                      onSelected == "USD" ? FontWeight.w600 : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "USD" ? buildIndicatorLine() : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  InkWell buildRowTitleEUR() {
    return InkWell(
      onTap: onClickEUR,
      child: Container(
        width: 25.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EUR",
              style: TextStyle(
                  color: onSelected == "EUR"
                      ? AppColors.icon_color
                      : AppColors.infoContentDialogColor,
                  fontSize: LocalHelper.getFontSize(14),
                  fontFamily: 'Poppins',
                  fontWeight:
                      onSelected == "EUR" ? FontWeight.w600 : FontWeight.w400),
            ),
            SizedBox(
              height: 0.67.h,
            ),
            onSelected == "EUR" ? buildIndicatorLine() : buildNonIndicatorLine()
          ],
        ),
      ),
    );
  }

  Container buildIndicatorLine() {
    return Container(
      height: 1,
      width: 25.w,
      color: AppColors.SignInColorGradientStart,
    );
  }

  Container buildNonIndicatorLine() {
    return Container(
      height: 1,
      width: 25.w,
      color: AppColors.textFormUnderLineColor,
    );
  }

  Widget returnCurrency() {
    if (onSelected == "TÜMÜ") {
      return AccountBalancePage(
        getCurrency: "TÜMÜ",
      );
    } else if (onSelected == "TRY") {
      return AccountBalancePage(
        getCurrency: "TRY",
      );
    } else if (onSelected == "USD") {
      return AccountBalancePage(
        getCurrency: "USD",
      );
    } else if (onSelected == "EUR") {
      return AccountBalancePage(
        getCurrency: "EUR",
      );
    }
    return AccountBalancePage(
      getCurrency: "TÜMÜ",
    );
  }
}
