import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/all_transaction_renewed.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class FilterBodyPage extends StatefulWidget {
  final String bankCode;

  FilterBodyPage({required this.bankCode});

  @override
  _FilterBodyPageState createState() => _FilterBodyPageState();
}

class _FilterBodyPageState extends State<FilterBodyPage> {
  TextEditingController minimumAmountController = TextEditingController();
  TextEditingController maximumAmountController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  String gelir = "Gelir";
  String gider = "Gider";
  String allIslem = "Tümü";

  String TL = "TL";
  String EUR = "EUR";
  String USD = "USD";
  String All = "Tümü";

  String customCurrency = "TL";

  String customIslem = "Gelir";

  @override
  void initState() {
    minimumAmountController.text = "0";
    maximumAmountController.text = "0";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildFilterDialogContainer();
  }

  onClickBack() {
    Get.back();
  }

  onClickApply() {
    int value = 0;
    if (double.parse(minimumAmountController.text) > 0 &&
        double.parse(maximumAmountController.text) > 0 &&
        double.parse(minimumAmountController.text) <
            double.parse(maximumAmountController.text)) {
      if (startDate != DateTime.now() || endDate != DateTime.now()) {
        value = 2;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AllTransactionRenewed(
              birimTip: customCurrency,
              islemTip: customIslem,
              addHeader: true,
              addDateTimeFilter: true,
              addFilter: true,
              minAmount: double.parse(minimumAmountController.text),
              maxAmount: double.parse(maximumAmountController.text),
              numberOfFilter: value,
              bankCode: widget.bankCode,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      } else {
        value = 1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTransactionRenewed(
              birimTip: customCurrency,
              islemTip: customIslem,
              addHeader: true,
              addFilter: true,
              addDateTimeFilter: false,
              minAmount: double.parse(minimumAmountController.text),
              maxAmount: double.parse(maximumAmountController.text),
              numberOfFilter: value,
              bankCode: widget.bankCode,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      }
    } else if (startDate != DateTime.now() || endDate != DateTime.now()) {
      if (double.parse(minimumAmountController.text) > 0 &&
          double.parse(maximumAmountController.text) > 0 &&
          double.parse(minimumAmountController.text) <
              double.parse(maximumAmountController.text)) {
        value = 2;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTransactionRenewed(
              birimTip: customCurrency,
              islemTip: customIslem,
              addHeader: true,
              addDateTimeFilter: true,
              addFilter: true,
              minAmount: double.parse(minimumAmountController.text),
              maxAmount: double.parse(maximumAmountController.text),
              numberOfFilter: value,
              bankCode: widget.bankCode,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      } else {
        value = 1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTransactionRenewed(
              birimTip: customCurrency,
              islemTip: customIslem,
              addDateTimeFilter: true,
              addHeader: true,
              addFilter: true,
              minAmount: double.parse(minimumAmountController.text),
              maxAmount: double.parse(maximumAmountController.text),
              numberOfFilter: value,
              bankCode: widget.bankCode,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllTransactionRenewed(
          birimTip: customCurrency,
          islemTip: customIslem,
          addHeader: true,
          addDateTimeFilter: false,
          addFilter: true,
          minAmount: double.parse(minimumAmountController.text),
          maxAmount: double.parse(maximumAmountController.text),
          numberOfFilter: value,
          bankCode: widget.bankCode,
          startDate: startDate,
          endDate: endDate,
        ),
      ),
    );
  }

  Container buildFilterDialogContainer() {
    return Container(
      height: 66.57.h,
      width: 93.60.w,
      padding: EdgeInsets.only(left: 4.83.w, bottom: 3.39.h, top: 1.h),
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
                  onTap: onClickBack,
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
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021, 6),
                                lastDate: DateTime.now());
                            if (picked != null && picked != DateTime.now())
                              setState(() {
                                startDate = picked;
                              });
                          },
                          child: Padding(
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
                                  color: AppColors.SignInColorGradientStart,
                                )),
                          ),
                        ),
                        Center(
                          child: Text(
                            startDate.toString().substring(0, 10),
                            style: TextStyle(
                                color: AppColors.filterAgainTextColor,
                                fontSize: LocalHelper.getFontSize(12),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWightColor,
                      border:
                          Border.all(color: AppColors.textFormUnderLineColor),
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
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021, 6),
                                  lastDate: DateTime.now());
                              if (picked != null && picked != DateTime.now())
                                setState(() {
                                  endDate = picked;
                                });
                            },
                            child: Padding(
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
                                    color: AppColors.SignInColorGradientStart,
                                  )),
                            ),
                          ),
                          Center(
                            child: Text(
                              endDate.toString().substring(0, 10),
                              style: TextStyle(
                                  color: AppColors.filterAgainTextColor,
                                  fontSize: LocalHelper.getFontSize(12),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWightColor,
                        border:
                            Border.all(color: AppColors.textFormUnderLineColor),
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
                  buildAmountFilter(minimumAmountController),
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
                    buildAmountFilter(maximumAmountController),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 2.71.h,
          ),
          buildRadioButtonsRow(),
          SizedBox(
            height: 2.34.h,
          ),
          Row(
            children: [
              buildDialogButtonxxx(false, onClickBack),
              SizedBox(
                width: 2.17.w,
              ),
              buildDialogButtonxxx(true, onClickApply),
            ],
          )
        ],
      ),
    );
  }

  Container buildAmountFilter(TextEditingController valueController) {
    return Container(
      width: 30.02.w,
      height: 4.48.h,
      decoration: BoxDecoration(
        color: AppColors.primaryWightColor,
        border: Border.all(color: AppColors.textFormUnderLineColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        controller: valueController,
        style: TextStyle(
            color: AppColors.filterAgainTextColor,
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFormUnderLineColor),
              borderRadius: BorderRadius.circular(5),
            ),
            fillColor: AppColors.primaryWightColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFormUnderLineColor),
              borderRadius: BorderRadius.circular(5),
            )),
      ),
    );
  }

  Row buildRadioButtonsRow() {
    return Row(
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
                  customCurrency = TL;
                });
              },
              child: buildEachRadioBtn(
                "TL",
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  customCurrency = USD;
                });
              },
              child: buildEachRadioBtn(
                "USD",
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  customCurrency = EUR;
                });
              },
              child: buildEachRadioBtn(
                "EUR",
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  customCurrency = All;
                });
              },
              child: buildEachRadioBtn(
                "Tümü",
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
                    customIslem = gelir;
                  });
                },
                child: buildEachRadioBtnGelir(
                  "Gelir",
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    customIslem = gider;
                  });
                },
                child: buildEachRadioBtnGelir(
                  "Gider",
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    customIslem = allIslem;
                  });
                },
                child: buildEachRadioBtnGelir(
                  "Tümü",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildEachRadioBtn(String content) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 1.08.h,
      ),
      child: Row(
        children: [
          Container(
            width: 4.40.w,
            height: 2.30.h,
            decoration: BoxDecoration(
                color: AppColors.primaryWightColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.SignInColorGradientStart)),
            child: customCurrency == content
                ? Center(
                    child: Container(
                      width: 2.65.w,
                      height: 1.49.h,
                      decoration: BoxDecoration(
                          color: AppColors.SignInColorGradientStart,
                          shape: BoxShape.circle),
                    ),
                  )
                : Container(),
          ),
          SizedBox(
            width: 1.69.w,
          ),
          Text(
            content,
            style: TextStyle(
              color: AppColors.infoContentDialogColor,
              fontSize: LocalHelper.getFontSize(12),
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Padding buildEachRadioBtnGelir(String content) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 1.08.h,
      ),
      child: Row(
        children: [
          Container(
            width: 4.40.w,
            height: 2.30.h,
            decoration: BoxDecoration(
                color: AppColors.primaryWightColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.SignInColorGradientStart)),
            child: customIslem == content
                ? Center(
              child: Container(
                width: 2.65.w,
                height: 1.49.h,
                decoration: BoxDecoration(
                    color: AppColors.SignInColorGradientStart,
                    shape: BoxShape.circle),
              ),
            )
                : Container(),
          ),
          SizedBox(
            width: 1.69.w,
          ),
          Text(
            content,
            style: TextStyle(
              color: AppColors.infoContentDialogColor,
              fontSize: LocalHelper.getFontSize(12),
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  InkWell buildDialogButtonxxx(bool leftOrRight, VoidCallback onTap) {
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
                    customTextDialogxxx("Uygula", AppColors.primaryWightColor, 14))
            : Center(
                child: customTextDialogxxx(
                    "Sıfırla", AppColors.SignInColorGradientStart, 14)),
      ),
    );
  }

  Text customTextDialogxxx(String content, Color color, double fontSize) {
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

}
