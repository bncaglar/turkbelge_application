import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/logic/groupCompany_sm/group_company_sm_cubit.dart';
import 'package:turkbelge_application/utilities/colors.dart';

abstract class LocalHelper {
  static final log = Logger();

  static double getFontSize(double? fontSize) {
    fontSize = ((fontSize! * 30.0) / 35.0).sp;
    return fontSize;
  }

  static String getCurrencyMethod(String currency) {
    switch (currency) {
      case "TRY":
        {
          return "TL";
        }
      case "EUR":
        {
          return "EUR";
        }
      case "USD":
        {
          return "USD";
        }
    }
    return "";
  }

  // static String getSessionId() {
  //   AccountAndTransactionState state = AccountAndTransactionCubit().state;
  //   if (state is AccountAndTransactionInitial) {
  //     return "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E";
  //   } else if (state is AccountAndTransactionEmit) {
  //     return "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C";
  //   }
  //   return "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E";
  // }

  static String getBankName(String bankCode) {
    switch (bankCode) {
      case "ZB00":
        {
          return "Ziraat Bankası";
        }
      case "IB00":
        {
          return "Türkiye İş Bankası";
        }
      case "KB00":
        {
          return "KuveytTürk";
        }
      case "VB00":
        {
          return "VakıfBank";
        }
      case "GB00":
        {
          return "Garanti Bankası";
        }
      case "SB00":{
        return "Şekerbank";
      }
    }
    return "";
  }

  static String getBankLogoString(String bankCode) {
    switch (bankCode) {
      case "ZB00":
        {
          return "assets/ziraat.png";
        }
      case "IB00":
        {
          return "assets/1280px-Türkiye_İş_Bankası_logo.svg.png";
        }
      case "KB00":
        {
          return "assets/kuveyt_logo.png";
        }
      case "VB00":
        {
          return "assets/vakifbank.png";
        }
      case "GB00":
        {
          return "assets/garanti_logo.png";
        }
      case "SB00":{
        return "assets/sekerbank.png";
      }
    }
    return "";
  }

  static void showTheBottomSheet(
      {required BuildContext context, required Widget child}) {
    log.i("showTheBottomSheet started");

    final straightLine = Padding(
      padding: EdgeInsets.only(top: 2.19.h, left: 45.w, right: 43.8.w),
      child: Container(
        height: 1,
        width: 11.11.w,
        color: AppColors.primaryWightColor,
      ),
    );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _portraitBottomSheet(straightLine, child);
      },
    );
  }

  static Container _portraitBottomSheet(Padding straightLine, Widget child) {
    return Container(
      width: double.infinity,
      height: 30.16.h,
      child: Column(
        children: [
          straightLine,
          child,
        ],
      ),
      decoration: BoxDecoration(
        color: AppColors.modalBottomSheetColor,
      ),
    );
  }
}
