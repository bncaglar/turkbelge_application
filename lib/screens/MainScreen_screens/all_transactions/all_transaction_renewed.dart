import 'dart:async';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/transition_page.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class AllTransactionRenewed extends StatefulWidget {
  final double minAmount;
  final double maxAmount;
  final String bankCode;
  final DateTime startDate;
  final DateTime endDate;
  final bool addHeader;
  final bool addDateTimeFilter;
  final birimTip;
  final islemTip;
  bool addFilter;
  int numberOfFilter;

  AllTransactionRenewed(
      {required this.addDateTimeFilter,
      required this.islemTip,
      required this.birimTip,
      required this.startDate,
      required this.endDate,
      required this.addHeader,
      required this.minAmount,
      required this.maxAmount,
      required this.addFilter,
      required this.numberOfFilter,
      required this.bankCode});

  @override
  _AllTransactionRenewedState createState() => _AllTransactionRenewedState();
}

class _AllTransactionRenewedState extends State<AllTransactionRenewed> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
  TextEditingController searchController = TextEditingController();
  bool removeHeader = true;
  String minimumAmount = "0";
  static double maxAmount = double.infinity;
  String maximumAmount = maxAmount.toString();

  DateTime startDatex = DateTime(2021, 6);
  DateTime endDatex = DateTime.now();

  setSf() {
    setState(() {});
  }

  String customCurrencyx = "Tümü";
  String customIslemx = "Tümü";

  onClickResetAll() {
    setState(() {
      minimumAmount = "0";
      double maxAmount = double.infinity;
      maximumAmount = maxAmount.toString();
      startDatex = DateTime(2021, 6);
      endDatex = DateTime.now();
      customCurrencyx = "Tümü";
      customIslemx = "Tümü";
    });
  }

  onClickDekontz() {
    String money = "550";
    String mds = money.replaceAll(",", "");
    double mdsx = double.parse(mds.replaceAll(".", ""));

    print(oCcy.format(double.parse(money)));
  }

  onClickBack() {
    Get.back();
  }

  onClickEachBox(
      DateTimeBuilder, amount, remainingBalance, description, getCurrency) {
    AwesomeDialog(
      addOkBtn: false,
      width: 800,
      showCloseIcon: false,
      dialogBackgroundColor: Colors.white,
      btnOkColor: AppColors.dismissRedColor,
      body: transactionDetailsDialog(
          DateTimeBuilder, amount, remainingBalance, description, getCurrency),
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.NO_HEADER,
    ).show();
  }

  onClickBuildFilter() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController minimumAmountController =
              TextEditingController();
          TextEditingController maximumAmountController =
              TextEditingController();
          minimumAmountController.text = "0";
          maximumAmountController.text = "0";
          DateTime startDate = DateTime(2021, 6);
          DateTime endDate = DateTime.now();

          String gelir = "Gelir";
          String gider = "Gider";
          String allIslem = "Tümü";

          String TL = "TL";
          String EUR = "EUR";
          String USD = "USD";
          String All = "Tümü";

          String customCurrency = "Tümü";
          String customIslem = "Tümü";

          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                insetPadding: EdgeInsets.only(
                  top: 10.h,
                  left: 4.83.w,
                  bottom: 3.39.h,
                  right: 4.83.w,
                ),
                actions: <Widget>[
                  Container(
                    height: 66.57.h,
                    width: 93.60.w,
                    padding:
                        EdgeInsets.only(left: 4.83.w, bottom: 3.39.h, top: 1.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWightColor,
                      //border: Border.all(color: AppColors.headerBelowColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Filtreleme",
                              style: TextStyle(
                                  color: AppColors.SignInColorGradientStart,
                                  fontSize: LocalHelper.getFontSize(20),
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.83.w),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  "svg/clear.svg",
                                  color: AppColors.clearIconColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.71.h, bottom: 1.22.h),
                          child: Text(
                            "Tarih Aralığı",
                            style: TextStyle(
                                color: AppColors.headerColor,
                                fontSize: LocalHelper.getFontSize(13),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tarihinden",
                                  style: TextStyle(
                                      color: AppColors.infoContentDialogColor,
                                      fontFamily: 'Poppins',
                                      fontSize: LocalHelper.getFontSize(9),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Container(
                                  width: 30.02.w,
                                  height: 4.48.h,
                                  child: InkWell(
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: startDate,
                                              firstDate: startDate,
                                              lastDate: endDate);
                                      if (picked != null &&
                                          picked != DateTime.now())
                                        setState(() {
                                          startDate = picked;
                                        });
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0.88.h,
                                            bottom: 0.88.h,
                                            left: 1.69.w,
                                            right: 2.17.w,
                                          ),
                                          child: Container(
                                              height: 2.71.h,
                                              width: 4.83.w,
                                              child: SvgPicture.asset(
                                                "svg/dateTime_picker.svg",
                                                color: AppColors
                                                    .SignInColorGradientStart,
                                              )),
                                        ),
                                        Center(
                                          child: Text(
                                            startDate
                                                .toString()
                                                .substring(0, 10),
                                            style: TextStyle(
                                                color: AppColors
                                                    .filterAgainTextColor,
                                                fontSize:
                                                    LocalHelper.getFontSize(12),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryWightColor,
                                    border: Border.all(
                                        color:
                                            AppColors.textFormUnderLineColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.83.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tarihinden",
                                    style: TextStyle(
                                        color: AppColors.infoContentDialogColor,
                                        fontFamily: 'Poppins',
                                        fontSize: LocalHelper.getFontSize(9),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                    width: 30.02.w,
                                    height: 4.48.h,
                                    child: InkWell(
                                      onTap: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: startDate,
                                                firstDate: startDate,
                                                lastDate: endDate);
                                        if (picked != null &&
                                            picked != DateTime.now())
                                          setState(() {
                                            startDate = picked;
                                          });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 0.88.h,
                                              bottom: 0.88.h,
                                              left: 1.69.w,
                                              right: 2.17.w,
                                            ),
                                            child: Container(
                                                height: 2.71.h,
                                                width: 4.83.w,
                                                child: SvgPicture.asset(
                                                  "svg/dateTime_picker.svg",
                                                  color: AppColors
                                                      .SignInColorGradientStart,
                                                )),
                                          ),
                                          Center(
                                            child: Text(
                                              endDate
                                                  .toString()
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                  color: AppColors
                                                      .filterAgainTextColor,
                                                  fontSize:
                                                      LocalHelper.getFontSize(
                                                          12),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryWightColor,
                                      border: Border.all(
                                          color:
                                              AppColors.textFormUnderLineColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 2.71.h,
                            bottom: 1.22.h,
                          ),
                          child: Text(
                            "Miktar",
                            style: TextStyle(
                                color: AppColors.headerColor,
                                fontSize: LocalHelper.getFontSize(13),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Minimum miktar",
                                  style: TextStyle(
                                      color: AppColors.infoContentDialogColor,
                                      fontFamily: 'Poppins',
                                      fontSize: LocalHelper.getFontSize(9),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Container(
                                  width: 30.02.w,
                                  height: 4.48.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryWightColor,
                                    border: Border.all(
                                        color:
                                            AppColors.textFormUnderLineColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    controller: minimumAmountController,
                                    style: TextStyle(
                                        color: AppColors.filterAgainTextColor,
                                        fontSize: LocalHelper.getFontSize(12),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors
                                                  .textFormUnderLineColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        fillColor: AppColors.primaryWightColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors
                                                  .textFormUnderLineColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.83.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Maximum miktar",
                                    style: TextStyle(
                                        color: AppColors.infoContentDialogColor,
                                        fontFamily: 'Poppins',
                                        fontSize: LocalHelper.getFontSize(9),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                    width: 30.02.w,
                                    height: 4.48.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryWightColor,
                                      border: Border.all(
                                          color:
                                              AppColors.textFormUnderLineColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.right,
                                      controller: maximumAmountController,
                                      style: TextStyle(
                                          color: AppColors.filterAgainTextColor,
                                          fontSize: LocalHelper.getFontSize(12),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors
                                                    .textFormUnderLineColor),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          fillColor:
                                              AppColors.primaryWightColor,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors
                                                    .textFormUnderLineColor),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.71.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Birim Tipi",
                                  style: TextStyle(
                                      color: AppColors.headerColor,
                                      fontSize: LocalHelper.getFontSize(13),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                                SizedBox(
                                  height: 1.76.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      customCurrency = All;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 1.08.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4.40.w,
                                          height: 2.30.h,
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.primaryWightColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors
                                                      .SignInColorGradientStart)),
                                          child: customCurrency == "Tümü"
                                              ? Center(
                                                  child: Container(
                                                    width: 2.65.w,
                                                    height: 1.49.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .SignInColorGradientStart,
                                                        shape: BoxShape.circle),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 1.69.w,
                                        ),
                                        Text(
                                          "Tümü",
                                          style: TextStyle(
                                            color: AppColors
                                                .infoContentDialogColor,
                                            fontSize:
                                                LocalHelper.getFontSize(12),
                                            fontFamily: 'Poppins',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      customCurrency = TL;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 1.08.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4.40.w,
                                          height: 2.30.h,
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.primaryWightColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors
                                                      .SignInColorGradientStart)),
                                          child: customCurrency == "TL"
                                              ? Center(
                                                  child: Container(
                                                    width: 2.65.w,
                                                    height: 1.49.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .SignInColorGradientStart,
                                                        shape: BoxShape.circle),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 1.69.w,
                                        ),
                                        Text(
                                          TL,
                                          style: TextStyle(
                                            color: AppColors
                                                .infoContentDialogColor,
                                            fontSize:
                                                LocalHelper.getFontSize(12),
                                            fontFamily: 'Poppins',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      customCurrency = USD;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 1.08.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4.40.w,
                                          height: 2.30.h,
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.primaryWightColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors
                                                      .SignInColorGradientStart)),
                                          child: customCurrency == "USD"
                                              ? Center(
                                                  child: Container(
                                                    width: 2.65.w,
                                                    height: 1.49.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .SignInColorGradientStart,
                                                        shape: BoxShape.circle),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 1.69.w,
                                        ),
                                        Text(
                                          "USD",
                                          style: TextStyle(
                                            color: AppColors
                                                .infoContentDialogColor,
                                            fontSize:
                                                LocalHelper.getFontSize(12),
                                            fontFamily: 'Poppins',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      customCurrency = EUR;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 1.08.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 4.40.w,
                                          height: 2.30.h,
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.primaryWightColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors
                                                      .SignInColorGradientStart)),
                                          child: customCurrency == "EUR"
                                              ? Center(
                                                  child: Container(
                                                    width: 2.65.w,
                                                    height: 1.49.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .SignInColorGradientStart,
                                                        shape: BoxShape.circle),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 1.69.w,
                                        ),
                                        Text(
                                          "EUR",
                                          style: TextStyle(
                                            color: AppColors
                                                .infoContentDialogColor,
                                            fontSize:
                                                LocalHelper.getFontSize(12),
                                            fontFamily: 'Poppins',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 28.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "İşlem Tipi",
                                    style: TextStyle(
                                        color: AppColors.headerColor,
                                        fontSize: LocalHelper.getFontSize(13),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                  ),
                                  SizedBox(
                                    height: 1.76.h,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        customIslem = allIslem;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 1.08.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4.40.w,
                                            height: 2.30.h,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.primaryWightColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors
                                                        .SignInColorGradientStart)),
                                            child: customIslem == "Tümü"
                                                ? Center(
                                                    child: Container(
                                                      width: 2.65.w,
                                                      height: 1.49.h,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .SignInColorGradientStart,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(
                                            width: 1.69.w,
                                          ),
                                          Text(
                                            "Tümü",
                                            style: TextStyle(
                                              color: AppColors
                                                  .infoContentDialogColor,
                                              fontSize:
                                                  LocalHelper.getFontSize(12),
                                              fontFamily: 'Poppins',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        customIslem = gelir;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 1.08.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4.40.w,
                                            height: 2.30.h,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.primaryWightColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors
                                                        .SignInColorGradientStart)),
                                            child: customIslem == "Gelir"
                                                ? Center(
                                                    child: Container(
                                                      width: 2.65.w,
                                                      height: 1.49.h,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .SignInColorGradientStart,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(
                                            width: 1.69.w,
                                          ),
                                          Text(
                                            "Gelir",
                                            style: TextStyle(
                                              color: AppColors
                                                  .infoContentDialogColor,
                                              fontSize:
                                                  LocalHelper.getFontSize(12),
                                              fontFamily: 'Poppins',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        customIslem = gider;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 1.08.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4.40.w,
                                            height: 2.30.h,
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.primaryWightColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors
                                                        .SignInColorGradientStart)),
                                            child: customIslem == "Gider"
                                                ? Center(
                                                    child: Container(
                                                      width: 2.65.w,
                                                      height: 1.49.h,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .SignInColorGradientStart,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(
                                            width: 1.69.w,
                                          ),
                                          Text(
                                            "Gider",
                                            style: TextStyle(
                                              color: AppColors
                                                  .infoContentDialogColor,
                                              fontSize:
                                                  LocalHelper.getFontSize(12),
                                              fontFamily: 'Poppins',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.34.h,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 5.70.h,
                                width: 32.71.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.boxColor),
                                ),
                                child: Center(
                                    child: Text(
                                  "Sıfırla",
                                  style: TextStyle(
                                      color: AppColors.SignInColorGradientStart,
                                      fontSize: LocalHelper.getFontSize(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 2.17.w,
                            ),
                            InkWell(
                              onTap: () {
                                if (minimumAmountController.text == "0" &&
                                    maximumAmountController.text == "0") {
                                  setState(() {
                                    startDatex = startDate;
                                    endDatex = endDate;
                                    customIslemx = customIslem;
                                    customCurrencyx = customCurrency;
                                  });
                                } else if (minimumAmountController.text ==
                                    "0") {
                                  setState(() {
                                    startDatex = startDate;
                                    endDatex = endDate;
                                    maximumAmount =
                                        maximumAmountController.text;
                                    customIslemx = customIslem;
                                    customCurrencyx = customCurrency;
                                  });
                                } else if (maximumAmountController.text ==
                                    "0") {
                                  setState(() {
                                    startDatex = startDate;
                                    endDatex = endDate;
                                    minimumAmount =
                                        minimumAmountController.text;
                                    customIslemx = customIslem;
                                    customCurrencyx = customCurrency;
                                  });
                                } else {
                                  setState(() {
                                    startDatex = startDate;
                                    endDatex = endDate;
                                    maximumAmount =
                                        maximumAmountController.text;
                                    minimumAmount =
                                        minimumAmountController.text;
                                    customIslemx = customIslem;
                                    customCurrencyx = customCurrency;
                                  });
                                }
                                setSf();
                                Get.back();
                              },
                              child: Container(
                                height: 5.70.h,
                                width: 32.71.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.SignInColorGradientStart,
                                      AppColors.SignInColorGradientEnd
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "Uygula",
                                  style: TextStyle(
                                      color: AppColors.primaryWightColor,
                                      fontSize: LocalHelper.getFontSize(14),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Container transactionDetailsDialog(String DateTimeBuilder, amount,
      remainingBalance, description, getCurrency) {
    return Container(
      height: 44.70.h,
      width: 84.54.w,
      decoration: BoxDecoration(
        color: AppColors.primaryWightColor,
        //border: Border.all(color: AppColors.headerBelowColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 1.h,
          left: 4.40.w,
          right: 4.40.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                children: [
                  customTextDialog(
                    "İşlem Detayı",
                    AppColors.icon_color,
                    15,
                  ),
                  SizedBox(
                    height: 1.90.h,
                  ),
                  customRowDialog(
                      "İşlem Tarihi", DateTimeBuilder.substring(0, 10).trim()),
                  customRowDialog(
                      "İşlem Saati", DateTimeBuilder.substring(11, 16)),
                  customRowDialog("Tutar",
                      "${oCcy.format(double.parse(amount))} ${buildCurrencyString(getCurrency)}"),
                  customRowDialog("Kalan Bakiye",
                      "${oCcy.format(double.parse(remainingBalance))} ${buildCurrencyString(getCurrency)}"),
                ],
              ),
            ),
            Flexible(
                flex: 2,
                child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 0.81.h,
                    ),
                    child: customDescription(description))),
            Flexible(
              flex: 4,
              child: Column(
                children: [
                  SizedBox(
                    height: 2.58.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDialogButton(false, onClickBack),
                      buildDialogButton(true, onClickDekontz),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String buildCurrencyString(getCurrency) {
    if (getCurrency == "TRY") {
      return "TL";
    } else if (getCurrency == "EUR") {
      return "EUR";
    } else if (getCurrency == "USD") {
      return "USD";
    }
    return "";
  }

  InkWell buildDialogButton(bool leftOrRight, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 5.70.h,
        width: 32.71.w,
        decoration: leftOrRight
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.SignInColorGradientStart,
                    AppColors.SignInColorGradientEnd
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Colors.white,
                border: Border.all(color: AppColors.boxColor),
              ),
        child: leftOrRight
            ? Center(
                child:
                    customTextDialog("Dekont", AppColors.primaryWightColor, 14))
            : Center(
                child: customTextDialog(
                    "Geri", AppColors.SignInColorGradientStart, 14)),
      ),
    );
  }

  Padding customRowDialog(String leftValue, String rightValue) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 0.81.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextDialog(
            leftValue,
            AppColors.filterAgainTextColor,
            12,
          ),
          customTextDialog(
            rightValue,
            AppColors.filterAgainTextColor,
            12,
          ),
        ],
      ),
    );
  }

  Row customDescription(String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customTextDialog(
          "Açıklama",
          AppColors.filterAgainTextColor,
          11,
        ),
        SizedBox(
          width: 1.w,
        ),
        Container(
          height: 10.h,
          width: 50.w,
          child: Text(
            "${description}",
            textAlign: TextAlign.right,
            maxLines: 3,
            style: TextStyle(
                color: AppColors.filterAgainTextColor,
                fontSize: LocalHelper.getFontSize(11),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Text customTextDialog(String content, Color color, double fontSize) {
    return Text(
      content,
      style: TextStyle(
          color: color,
          fontSize: LocalHelper.getFontSize(fontSize),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
    );
  }

  onRefresh() {
    setState(() {});
  }

  final log = Logger();
  String descOrAsc = "desc";
  String transactionId = "";

  onClickDekont(transactionIdentifier) async {
    log.i(transactionIdentifier);
    setState(() {
      transactionId = transactionIdentifier;
    });
  }

  onClickOldNew() {
    log.i("onClickOldNew started");
    if (descOrAsc == "desc") {
      setState(() {
        descOrAsc = "asc";
      });
    } else {
      setState(() {
        setState(() {
          descOrAsc = "desc";
        });
      });
    }
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
        buildUp(),
        buildListView(),
      ],
    );
  }

  Flexible buildUp() {
    return Flexible(
      flex: FocusScope.of(context).hasFocus ? 1 : 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            headerRow(),

            ///TODO WE LL PUT THE SEARCH HERE
            buildFilterRow(),
            buildStraightHeaderLine(),
          ],
        ),
      ),
    );
  }

  Stack headerRow() {
    return Stack(
      children: [
        widget.addHeader
            ? buildHeaderText()
            : Container(
                height: 1.h,
              ),
        widget.addHeader ? Container() : Container(),
      ],
    );
  }

  Container buildSearch() {
    return Container(
      padding: EdgeInsets.only(right: 4.w),
      height: 10.h,
      child: AnimSearchBar(
        helpText: "Arama",
        rtl: true,
        closeSearchOnSuffixTap: true,
        autoFocus: false,
        width: 87.w,
        textController: searchController,
        onSuffixTap: () {
          searchController.clear();
        },
      ),
    );
  }

  Container buildHeaderText() {
    return Container(
      height: 10.h,
      child: Center(
        child: Text(
          "Hareketler",
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(17),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Padding buildFilterRow() {
    return Padding(
      padding: EdgeInsets.only(
        right: 7.72.w,
        left: 7.72.w,
        bottom: 1.42.h,
      ),
      child: Row(
        children: <Widget>[
          buildAscendingFilter(),
          buildFilter(),
          buildResetText(),
        ],
      ),
    );
  }

  Padding buildAscendingFilter() {
    return Padding(
      padding: EdgeInsets.only(
        right: 2.17.w,
      ),
      child: InkWell(
        onTap: onClickOldNew,
        child: Container(
          width: 40.33.w,
          height: 4.89.h,
          decoration: BoxDecoration(
            color: AppColors.primaryWightColor,
            border: Border.all(color: AppColors.filterBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.boxShadowColor.withOpacity(0.10),
                spreadRadius: 3,
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 4.83.w,
              right: 4.83.w,
            ),
            child: descOrAsc == "desc"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Yeniden",
                        style: TextStyle(
                          color: AppColors.filterAgainTextColor,
                          fontFamily: 'Poppins',
                          fontSize: LocalHelper.getFontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SvgPicture.asset("svg/arrow_up_down.svg"),
                      Text(
                        "Eskiye",
                        style: TextStyle(
                          color: AppColors.filterAgainTextColor,
                          fontFamily: 'Poppins',
                          fontSize: LocalHelper.getFontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Eskiden",
                        style: TextStyle(
                          color: AppColors.filterAgainTextColor,
                          fontFamily: 'Poppins',
                          fontSize: LocalHelper.getFontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SvgPicture.asset("svg/arrow_up_down.svg"),
                      Text(
                        "Yeniye",
                        style: TextStyle(
                          color: AppColors.filterAgainTextColor,
                          fontFamily: 'Poppins',
                          fontSize: LocalHelper.getFontSize(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Padding buildFilter() {
    return Padding(
      padding: EdgeInsets.only(right: 2.89.w),
      child: InkWell(
        onTap: onClickBuildFilter,
        child: Container(
          height: 4.89.h,
          width: 25.12.w,
          decoration: BoxDecoration(
            color: AppColors.primaryWightColor,
            border: Border.all(color: AppColors.filterBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.boxShadowColor.withOpacity(0.10),
                spreadRadius: 3,
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 1.93.w,
              right: 1.93.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset("svg/arrow_up_down.svg"),
                Text(
                  "Filtre",
                  style: TextStyle(
                    color: AppColors.filterAgainTextColor,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 2.98.h,
                  width: 5.31.w,
                  decoration: BoxDecoration(
                    color: AppColors.navigationBorderColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.numberOfFilter}",
                      style: TextStyle(
                        color: AppColors.filterAgainTextColor,
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildResetText() {
    return InkWell(
      onTap: onClickResetAll,
      child: Container(
        width: 14.w,
        child: Center(
          child: Text(
            "Tümünü Sıfırla",
            style: TextStyle(
              color: AppColors.SignInColorGradientStart,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(12),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Container buildStraightHeaderLine() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.SignInColorGradientStart,
    );
  }

  Flexible buildListView() {
    return Flexible(
      flex: widget.addHeader ? 4 : 9,
      child: Container(
        color: AppColors.allTransactionBackgroundColor,
        child: buildGroupCompany(), //todo buildA
      ),
    );
  }

  BlocBuilder buildGroupCompany() {
    return BlocBuilder<DropdownCubit, DropdownState>(builder: (context, state) {
      if (state is DropdownInitial) {
        return buildGetTransactionInfoMethodBuilder(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
      } else if (state is DropdownSecondCompany) {
        return buildGetTransactionInfoMethodBuilder(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
      }
      return Container();
    });
  }

  Future getTransactionInfoMethod(String sessionId) async {
    while (true) {
      try {
        var getBalance = await WsdlRequest()
            .getTransactionSorted(widget.bankCode, descOrAsc, sessionId);
        if (getBalance == "null") {
          return "null";
        }
        Map mapValue = Map<String, dynamic>.from(getBalance);
        if (mapValue["Transaction"] != null) {
          return mapValue;
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  FutureBuilder buildGetTransactionInfoMethodBuilder(String sessionId) {
    return FutureBuilder(
      future: getTransactionInfoMethod(sessionId),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return TransitionPage();
            }
          case ConnectionState.active:
            {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.textFormUnderLineColor,
                  ),
                ),
              );
            }
          default:
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return buildCurrencyBloc(snapshot.data);
              } else if (snapshot.hasError) {
                print(snapshot.error);

                return throwErrorWidget();
              }
            }
            return buildCurrencyBloc(snapshot.data);
        }
      },
    );
  }

  BlocBuilder buildCurrencyBloc(getData) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
      if (state is CurrencySmInitial) {
        return buildListViewBuilder(getData, "TRY");
      } else if (state is CurrencySMEUR) {
        return buildListViewBuilder(getData, "EUR");
      } else if (state is CurrencySMUSD) {
        return buildListViewBuilder(getData, "USD");
      }
      return Container();
    });
  }

  Widget throwErrorWidget() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {});
        },
        child: Container(
          color: Colors.white,
          height: 15.h,
          width: 50.w,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Bir hata oluştu!",
                  style: TextStyle(
                      color: AppColors.textFormUnderLineColor,
                      fontSize: LocalHelper.getFontSize(14),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  height: 4.5.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFormUnderLineColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text("Tekrar dene"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addFilterBuilder(
      bankCode,
      amount,
      remaining,
      getTime,
      borcAlacak,
      transactionName,
      transactionDescription,
      isReceiptProvided,
      transactionIdentifier,
      getCurrency) {
    String birimTip = birimTipBuilder();
    String islemTip = islemTipiBuilder();
    DateTime tDate = DateTime.parse(getTime);
    double amounts = double.parse(amount);
    if (startDatex.isBefore(tDate) == true && endDatex.isAfter(tDate) == true) {
      if (amounts > double.parse(minimumAmount) &&
          amounts < double.parse(maximumAmount)) {
        log.i("You are here !");
        if (customCurrencyx == "Tümü") {
          if (customIslemx == "Tümü") {
            return buildEachBox(
                bankCode,
                amount,
                remaining,
                getTime,
                borcAlacak,
                transactionName,
                transactionDescription,
                isReceiptProvided,
                transactionIdentifier,
                getCurrency);
          } else {
            return islemTip == borcAlacak
                ? buildEachBox(
                    bankCode,
                    amount,
                    remaining,
                    getTime,
                    borcAlacak,
                    transactionName,
                    transactionDescription,
                    isReceiptProvided,
                    transactionIdentifier,
                    getCurrency)
                : Container();
          }
        } else {
          if (birimTip == getCurrency) {
            if (customIslemx == "Tümü") {
              log.i("You are here !");

              return buildEachBox(
                  bankCode,
                  amount,
                  remaining,
                  getTime,
                  borcAlacak,
                  transactionName,
                  transactionDescription,
                  isReceiptProvided,
                  transactionIdentifier,
                  getCurrency);
            } else {
              return islemTip == borcAlacak
                  ? buildEachBox(
                      bankCode,
                      amount,
                      remaining,
                      getTime,
                      borcAlacak,
                      transactionName,
                      transactionDescription,
                      isReceiptProvided,
                      transactionIdentifier,
                      getCurrency)
                  : Container();
            }
          } else {
            return Container();
          }
        }
      }
      log.i("You are here !");

      return Container();
    } else {
      log.i("You are here !");
      return Container();
    }
    log.i("You are here !");
  }

  String birimTipBuilder() {
    String currencyBelirle = "";
    switch (customCurrencyx) {
      case "TL":
        {
          currencyBelirle = "TRY";
          break;
        }
      case "EUR":
        {
          currencyBelirle = "EUR";
          break;
        }
      case "USD":
        {
          currencyBelirle = "USD";
          break;
        }
    }
    return currencyBelirle;
  }

  String islemTipiBuilder() {
    String islemTipiBelirle = "";
    switch (customIslemx) {
      case "Gelir":
        {
          islemTipiBelirle = "A";
          break;
        }
      case "Gider":
        {
          islemTipiBelirle = "B";
          break;
        }
    }
    return islemTipiBelirle;
  }

  RefreshIndicator buildListViewBuilder(getData, currencyBloc) {
    return RefreshIndicator(
      child: getData["Transaction"].runtimeType == List
          ? ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: getData["Transaction"].length,
              itemBuilder: (context, index) {
                if (getData["Transaction"][index]["CurrencyType"] ==
                    currencyBloc) {
                  final transactionName =
                      getData["Transaction"][index]["TransactionName"];
                  final bankCode = getData["Transaction"][index]["BankCode"];
                  final borcAlacak =
                      getData["Transaction"][index]["BorcAlacak"];
                  final getTime =
                      getData["Transaction"][index]["TransactionDateTime"];
                  final amount =
                      getData["Transaction"][index]["TransactionAmount"];
                  final remaining =
                      getData["Transaction"][index]["RemainingBalance"];
                  final isReceiptProvided =
                      getData["Transaction"][index]["IsReceiptProvided"];
                  final transactionIdentifier =
                      getData["Transaction"][index]["TransactionIdentifier"];
                  final transactionDescription =
                      getData["Transaction"][index]["TransactionDescription"];
                  final getCurrency =
                      getData["Transaction"][index]["CurrencyType"];
                  return addFilterBuilder(
                      bankCode,
                      amount,
                      remaining,
                      getTime,
                      borcAlacak,
                      transactionName,
                      transactionDescription,
                      isReceiptProvided,
                      transactionIdentifier,
                      getCurrency);
                } else {
                  return Container();
                }
              },
            )
          : ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 1,
              itemBuilder: (context, index) {
                if (getData["Transaction"][index]["CurrencyType"] ==
                    currencyBloc) {
                  final transactionName =
                      getData["Transaction"]["TransactionName"];
                  final bankCode = getData["Transaction"]["BankCode"];
                  final borcAlacak = getData["Transaction"]["BorcAlacak"];
                  final getTime = getData["Transaction"]["TransactionDateTime"];
                  final amount = getData["Transaction"]["TransactionAmount"];
                  final remaining = getData["Transaction"]["RemainingBalance"];
                  final isReceiptProvided =
                      getData["Transaction"]["IsReceiptProvided"];
                  final transactionIdentifier =
                      getData["Transaction"]["TransactionIdentifier"];
                  final transactionDescription =
                      getData["Transaction"]["TransactionDescription"];
                  final getCurrency = getData["Transaction"]["CurrencyType"];
                  return addFilterBuilder(
                      bankCode,
                      amount,
                      remaining,
                      getTime,
                      borcAlacak,
                      transactionName,
                      transactionDescription,
                      isReceiptProvided,
                      transactionIdentifier,
                      getCurrency);
                }else{
                  return Container();
                }
              },
            ),
      color: AppColors.textFormUnderLineColor,
      onRefresh: () {
        return onRefresh();
      },
    );
  }

  Padding buildEachBox(
      String bankIconPath,
      String amount,
      String remainingBalance,
      dateTimeBuilder,
      borcAlacak,
      transactionNames,
      transactionDescription,
      isReceiptProvided,
      transactionIdentifier,
      getCurrency) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.22.h),
      child: Center(
        child: InkWell(
          onTap: () => onClickEachBox(dateTimeBuilder, amount, remainingBalance,
              transactionDescription, getCurrency),
          child: Container(
            height: 17.52.h,
            width: 94.68.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.allTransactionBoxShadowColor.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 5.07.w,
                    top: 2.85.h,
                  ),
                  child: isReceiptProvided == "true"
                      ? Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: () => onClickDekont(transactionIdentifier),
                              child: SvgPicture.asset("svg/receipt.svg")),
                        )
                      : Container(),
                ),
                buildBoxColumn(
                  bankIconPath,
                  amount,
                  remainingBalance,
                  dateTimeBuilder,
                  borcAlacak,
                  transactionNames,
                  transactionDescription,
                  getCurrency,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildBoxColumn(
      String bankIconPath,
      String amount,
      String remainingBalance,
      String dateTimeBuilder,
      borcAlacak,
      String transactionNames,
      String transactionDescription,
      currency) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.07.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 4.55.h,
                width: 24.w,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      LocalHelper.getBankLogoString(bankIconPath),
                      scale: 2.5,
                    )),
              ),
              Text(
                "${dateTimeBuilder.substring(0, 10)} ${dateTimeBuilder.substring(11, 16)}",
                style: TextStyle(
                  color: AppColors.icon_color,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(10),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 4.55.h,
                width: 24.w,
              ),
            ],
          ),
          transactionNames == "Banka Bu bilgiyi Sağlamamaktadır."
              ? Container()
              : Container(
                  width: 75.49.w,
                  child: Text(
                    transactionNames,
                    style: TextStyle(
                      color: AppColors.headerColor,
                      fontFamily: 'Poppins',
                      fontSize: LocalHelper.getFontSize(13),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          Text(
            transactionDescription,
            style: transactionNames == "Banka Bu bilgiyi Sağlamamaktadır."
                ? TextStyle(
                    color: AppColors.headerColor,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(12),
                    fontWeight: FontWeight.w600,
                  )
                : TextStyle(
                    color: AppColors.infoContentDialogColor,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(10),
                    fontWeight: FontWeight.w400,
                  ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 1.35.h,
          ),
          Center(
            child: Container(
              width: 89.85.w,
              height: 1,
              color: AppColors.allTransactionBoxStraightLineColor,
            ),
          ),
          SizedBox(
            height: 0.95.h,
          ),
          buildRevenue(amount, remainingBalance, borcAlacak, currency)
        ],
      ),
    );
  }

  Row buildRevenue(
      String amount, String remainingBalance, borcAlacak, currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRevenueTextColumn(amount, borcAlacak, currency),
        Container(
          height: 5.40.h,
          width: 1,
          color: AppColors.allTransactionBoxStraightLineColor,
        ),
        buildRemainingAmountColumn(remainingBalance, currency),
      ],
    );
  }

  Column buildRevenueTextColumn(String amount, borcAlacak, currency) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          borcAlacak == "A" ? "Gelir" : "Gider",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Row(
          children: [
            Text(
              borcAlacak == "A" ? "+ " : "- ",
              style: TextStyle(
                color: borcAlacak == "A"
                    ? AppColors.allTransactionGelirColor
                    : AppColors.SignInColorGradientStart,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Text(
                  oCcy.format(double.parse(amount)),
                  style: TextStyle(
                    color: borcAlacak == "A"
                        ? AppColors.allTransactionGelirColor
                        : AppColors.SignInColorGradientStart,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  LocalHelper.getCurrencyMethod(currency),
                  style: TextStyle(
                    color: borcAlacak == "A"
                        ? AppColors.allTransactionGelirColor
                        : AppColors.SignInColorGradientStart,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column buildRemainingAmountColumn(String remainingBalance, currency) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Kalan Bakiye",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Row(
          children: [
            Text(
              oCcy.format(double.parse(remainingBalance)),
              style: TextStyle(
                color: AppColors.infoContentDialogColor,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              LocalHelper.getCurrencyMethod(currency),
              style: TextStyle(
                color: AppColors.infoContentDialogColor,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
