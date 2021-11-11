import 'dart:ui';

import 'package:flutter/material.dart';

import 'hex_colors.dart';

class AppColors {
  static final backgroundPrimaryColor = HexColor("#000000");
  static final textPrimaryColor = HexColor("#86878B");
  static final primaryColor = HexColor("#BB86FC");
  static final primaryPinkColor = HexColor("#C248E3");
  static final primaryBlueColor = HexColor("#58B8F6");
  static final errorColor = HexColor("#FD2B1D");
  static final rememberMeBoxColor = HexColor("#C4C4C4");
  static final primaryWightColor = HexColor("#FFFFFF");
  static final primaryGreyColor = HexColor("#E8E8F2");
  static final textSkipColor = HexColor("#41C4E1");
  static final modalBottomSheetColor = HexColor("#1C1C1F");
  static final secondaryGrayColor = HexColor("#4F4F4F");
  static final backgroundProfileSmallIconColor = HexColor("#060606");
  static final forthGrayColor = HexColor("#BDBDBD");
  static final transparentGrayColor = HexColor("#434343");
  static final allNotificationsTextColor = HexColor("#8E8E93");
  static final dismissRedColor = HexColor("#CA2A20");
  static final dropDownMenuColor = HexColor("#323236");
  static final newColor4Background = HexColor("#1FE0D7");
  static final bottomNavigationBarColor = HexColor("#ACAEB0");
  static final homepageTextColor = HexColor("#f0f2f5");
  static final accountInfoColor = HexColor("#232423");
  static final homepageBankListBackgroundColor = HexColor("#f5f3f2");
  static final appBarBackgroundColor = HexColor("#24fff5");
  static final kremRengi = HexColor("#fffdd0");
  static final textFormUnderLineColor = HexColor("#C3C3C3");
  static final icon_color = HexColor("#4B4B4B");
  static final SignInColorGradientStart = HexColor("#DB2820");
  static final SignInColorGradientEnd = HexColor("##AC0700");
  static final phoneColor = HexColor("#C2120B");
  static final straightLineColor = HexColor("#CACACA");
  static final clearIconColor = HexColor("#BFBFBF");
  static final infoContentDialogColor = HexColor("#7B7B7B");
  static final countDownColor = HexColor("#606060");
  static final countDownBackgroundColor = HexColor("#E2E2E2");
  static final headerColor = HexColor("#686868");
  static final headerBelowColor = HexColor("#707070");
  static final navigationBorderColor = HexColor("#EFEFEF");
  static final homepageStraightLineColor = HexColor("#F0F0F0");
  static final accountsColor = HexColor("#FFCDCB");
  static final accountsAndBankStraightLine = HexColor("#FF9793");
  static final homepageUpBottomAlignStraightLineHorizontalColor = HexColor("#FFFFFF80");
  static final chartColorBlue = HexColor("#1769FF");
  static final chartColorYellow = HexColor("#F7B500");
  static final chartColorGreen = HexColor("#43D7B5");
  static final chartColorReddish = HexColor("#FE6669");
  static final piechartBalanceColor = HexColor("#3B3B3B");
  static final columnChartHalfDownContainerColor = HexColor("#F8F8F8");
  static final columnChartHalfDownContainerBorderColor = HexColor("#EBEBEB");
  static final truePercentageColor = HexColor("#00B42F");
  static final filterBorderColor = HexColor("#E3B5B3");
  static final boxShadowColor = HexColor("#00000029");
  static final filterAgainTextColor = HexColor("#5F5F5F");
  static final allTransactionBackgroundColor = HexColor("#F9F9F9");
  static final allTransactionBoxShadowColor = HexColor("#0000001F");
  static final allTransactionBoxStraightLineColor = HexColor("#D6D6D6");
  static final allTransactionGelirColor = HexColor("#32DD48");
  static final profileUserTextColor = HexColor("#FFCECC");
  static final profileTableBorderColor = HexColor("#FF8580");
  static final accountBalanceColor = HexColor("#090580");
  static final unVerifiedCheckBoxColor = HexColor("#F6F6F6");
  static final boxColor = HexColor("#C70900");

  static List pieColors = [
    profileUserTextColor,
    chartColorBlue,
    chartColorYellow,
    chartColorGreen,
    chartColorReddish,
    dismissRedColor,
    truePercentageColor,
    SignInColorGradientEnd
  ];
  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.white, spreadRadius: -8, offset: Offset(-5, -5), blurRadius: 17),
    BoxShadow(
        color: Colors.black.withOpacity(.2),
        spreadRadius: -3,
        offset: Offset(7, 7),
        blurRadius: 10)
  ];
}
