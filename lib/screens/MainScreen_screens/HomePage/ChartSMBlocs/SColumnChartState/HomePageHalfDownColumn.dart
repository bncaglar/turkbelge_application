import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/filter_sm/filter_sm_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/SColumnChartState/expansion_pannel_demo.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class HomePageHalfDownColumn extends StatefulWidget {
  @override
  _HomePageHalfDownColumnState createState() => _HomePageHalfDownColumnState();
}

class _HomePageHalfDownColumnState extends State<HomePageHalfDownColumn> {
  var listOfBanks = [
    "assets/2560px-Akbank_logo.svg.png",
    "assets/2560px-Akbank_logo.svg.png",
    "assets/1280px-DenizBank_logo.svg.png",
    "assets/1280px-Türkiye_İş_Bankası_logo.svg.png"
  ];

  var listOfDropDown = [true, false, false, false];

  var listofAccount = [
    2,
    1,
    4,
    9,
  ];

  var listOfBalance = [
    "309.550,00 TL",
    "2.350,00 TL",
    "309.335,00 TL",
    "592,00 TL",
  ];

  var changes = [
    "+ 5,250,00 TL",
    "- 250,00 TL",
    "+ 5,250,00 TL",
    "- 250,00 TL"
  ];

  var percentageChange = [
    "16,21%",
    "8,96%",
    "16,21%",
    "8,96%",
  ];

  var backgroundColor = [
    AppColors.columnChartHalfDownContainerColor,
    AppColors.primaryWightColor,
    AppColors.columnChartHalfDownContainerColor,
    AppColors.primaryWightColor
  ];
  bool xx = false;
  var trueFalse = [
    true,
    false,
    true,
    false,
  ];

  onClickOneDay() {
    context.read<FilterSmCubit>().changeFilterState(FilterSmOneDay());
  }

  onClickOneWeek() {
    context.read<FilterSmCubit>().changeFilterState(FilterSmOneWeek());
  }

  onClickOneMonth() {
    context.read<FilterSmCubit>().changeFilterState(FilterSmOneMonth());
  }

  onClickOneYear() {
    context.read<FilterSmCubit>().changeFilterState(FilterSmOneYear());
  }

  onClickFilterIcon() {
    showDialog(
        context: context,
        builder: (context) {

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
                    height: 53.57.h,
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
                        SizedBox(height: 3.12.h,),
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
                                width: 38.06.w,
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
                               ///todo
                                Get.back();
                              },
                              child: Container(
                                height: 5.70.h,
                                width: 38.w,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFilter(),
        // Container(
        //     height: 35.76.h, width: double.infinity, child: buildListView()),

        Container(
            height: 35.76.h,
            width: double.infinity,
            child: ExpansionPanelDemo(),),
      ],
    );
  }

  Padding buildFilter() {
    return Padding(
      padding: EdgeInsets.only(top: 2.58.h, right: 7.72.w, left: 7.72.w),
      child: buildFilterRow(),
    );
  }

  Row buildFilterRow() {
    return Row(
      children: <Widget>[
        buildFilterContainer(),
        SizedBox(
          width: 1.44.w,
        ),
        buildFilterIconContainer(),
      ],
    );
  }

  Container buildFilterContainer() {
    return Container(
      width: 75.60.w,
      height: 4.07.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.SignInColorGradientStart),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: buildCurrencyColorBloc(),
    );
  }

  BlocBuilder buildCurrencyColorBloc() {
    return BlocBuilder<FilterSmCubit, FilterSmState>(builder: (context, state) {
      print(state);
      if (state is FilterSmOneDay) {
        return Row(
          children: [
            buildFilterByDateTime(AppColors.SignInColorGradientStart, "1 Gün",
                AppColors.primaryWightColor, onClickOneDay),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Hafta",
                AppColors.headerColor, onClickOneWeek),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Ay",
                AppColors.headerColor, onClickOneMonth),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Yıl",
                AppColors.headerColor, onClickOneYear),
          ],
        );
      } else if (state is FilterSmOneWeek) {
        return Row(
          children: [
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Gün",
                AppColors.headerColor, onClickOneDay),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.SignInColorGradientStart, "1 Hafta",
                AppColors.primaryWightColor, onClickOneWeek),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Ay",
                AppColors.headerColor, onClickOneMonth),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Yıl",
                AppColors.headerColor, onClickOneYear),
          ],
        );
      } else if (state is FilterSmOneMonth) {
        return Row(
          children: [
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Gün",
                AppColors.headerColor, onClickOneDay),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Hafta",
                AppColors.headerColor, onClickOneWeek),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.SignInColorGradientStart, "1 Ay",
                AppColors.primaryWightColor, onClickOneMonth),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Yıl",
                AppColors.headerColor, onClickOneYear),
          ],
        );
      } else if (state is FilterSmOneYear) {
        return Row(
          children: [
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Gün",
                AppColors.headerColor, onClickOneDay),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Hafta",
                AppColors.headerColor, onClickOneWeek),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.primaryWightColor, "1 Ay",
                AppColors.headerColor, onClickOneMonth),
            buildStraightLine(),
            buildFilterByDateTime(AppColors.SignInColorGradientStart, "1 Yıl",
                AppColors.primaryWightColor, onClickOneYear),
          ],
        );
      }
      return Container();
    });
  }

  InkWell buildFilterByDateTime(Color backgroundColor, String label,
      Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 18.50.w,
        height: 3.80.h,
        child: Center(
          child: Container(
            height: 3.26.h,
            width: 16.97.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(13),
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildStraightLine() {
    return Container(
      height: 3.80.h,
      width: 1,
      color: AppColors.SignInColorGradientStart,
    );
  }

  InkWell buildFilterIconContainer() {
    return InkWell(
      onTap: onClickFilterIcon,
      child: Container(
        width: 7.24.w,
        height: 4.07.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.SignInColorGradientStart),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Center(
          child: SvgPicture.asset("svg/filter.svg"),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 2.44.h),
      itemCount: 4,
      itemBuilder: (context, index) {
        final logoPath = listOfBanks[index];
        final listOfAccountList = listofAccount[index];
        final balanceList = listOfBalance[index];
        final changesOnBalance = changes[index];
        final percentageChanges = percentageChange[index];
        final trueFalsex = trueFalse[index];
        var dropDownState = listOfDropDown[index];
        final backColor = backgroundColor[index];
        return buildEachBankRow(
            logoPath,
            listOfAccountList,
            balanceList,
            changesOnBalance,
            percentageChanges,
            trueFalsex,
            backColor,
            dropDownState);
      },
    );
  }

  Padding buildEachBankRow(
      String bankLogoSvg,
      int listofAccountList,
      String balanceList,
      String changesOnBalance,
      String percentageChanges,
      bool trueFalsex,
      Color color,
      bool dropDownState) {
    return Padding(
        padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w, bottom: 1.08.h),
        child: dropDownState
            ? xx
                ? dropDownColumn(
                    bankLogoSvg,
                    listofAccountList,
                    balanceList,
                    changesOnBalance,
                    percentageChanges,
                    trueFalsex,
                    color,
                    dropDownState)
                : eachBox(
                    bankLogoSvg,
                    listofAccountList,
                    balanceList,
                    changesOnBalance,
                    percentageChanges,
                    trueFalsex,
                    color,
                    dropDownState)
            : eachBox(
                bankLogoSvg,
                listofAccountList,
                balanceList,
                changesOnBalance,
                percentageChanges,
                trueFalsex,
                color,
                dropDownState),);
  }

  Container eachBox(
      String bankLogoSvg,
      int listofAccountList,
      String balanceList,
      String changesOnBalance,
      String percentageChanges,
      bool trueFalsex,
      Color color,
      bool dropDownState) {
    return Container(
      height: 8.69.h,
      width: 92.02.w,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: AppColors.columnChartHalfDownContainerBorderColor),
      ),
      child: Row(
        children: [
          buildBankLogo(bankLogoSvg, listofAccountList),
          Spacer(),
          buildRightSide(balanceList, changesOnBalance, percentageChanges,
              trueFalsex, dropDownState),
        ],
      ),
    );
  }

  Column dropDownColumn(
      String bankLogoSvg,
      int listofAccountList,
      String balanceList,
      String changesOnBalance,
      String percentageChanges,
      bool trueFalsex,
      Color color,
      bool dropDownState) {
    return Column(
      children: [
        eachBox(bankLogoSvg, listofAccountList, balanceList, changesOnBalance,
            percentageChanges, trueFalsex, color, dropDownState),
        Container(
          height: 6.92.h,
          width: 92.02.w,
          decoration: BoxDecoration(
              color: AppColors.primaryWightColor,
              border: Border.all(
                  color: AppColors.columnChartHalfDownContainerBorderColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 3.36.w,
              ),
              Container(
                height: 4.89.h,
                width: 1.20.w,
                decoration: BoxDecoration(
                  color: AppColors.textFormUnderLineColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              SizedBox(
                width: 2.65.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TR440001000711829964725001",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.headerColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "BUCA/İZMİR ŞUBESİ",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.infoContentDialogColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPercentageRow("5.21%", trueFalsex),
                  Text(
                    "+ 2,000,00 TL",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.infoContentDialogColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: 3.86.w,
              ),
            ],
          ),
        ),
        Container(
          height: 6.92.h,
          width: 92.02.w,
          decoration: BoxDecoration(
              color: AppColors.primaryWightColor,
              border: Border.all(
                  color: AppColors.columnChartHalfDownContainerBorderColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 3.36.w,
              ),
              Container(
                height: 4.89.h,
                width: 1.20.w,
                decoration: BoxDecoration(
                  color: AppColors.textFormUnderLineColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              SizedBox(
                width: 2.65.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TR440001000711829964725001",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.headerColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "EŞREFPAŞA/İZMİR ŞUBESİ",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.infoContentDialogColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPercentageRow("11,21%", trueFalsex),
                  Text(
                    "+ 3,250,00 TL",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.infoContentDialogColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: 3.86.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildBankLogo(String bankLogoSvg, int numberOfAcc) {
    return Padding(
      padding: EdgeInsets.only(left: 3.62.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              bankLogoSvg,
              scale: 2.1,
            ),
          ),
          Text(
            "$numberOfAcc Hesap",
            style: TextStyle(
              color: AppColors.infoContentDialogColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(10),
            ),
          ),
        ],
      ),
    );
  }

  Row buildRightSide(String balanceList, String changesOnBalance,
      String percentageChanges, bool trueFalsex, bool dropDownState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2.17.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildBalance(balanceList),
              Row(
                children: [
                  Text(
                    changesOnBalance,
                    style: TextStyle(
                      color: AppColors.infoContentDialogColor,
                      fontFamily: 'Poppins',
                      fontSize: LocalHelper.getFontSize(10),
                    ),
                  ),
                  SizedBox(
                    width: 1.44.w,
                  ),
                  buildPercentageRow(percentageChanges, trueFalsex),
                ],
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            if (percentageChanges == "16,21%") {
              setState(() {
                xx = !xx;
              });
            }
          },
          child: Container(
            width: 10.60.w,
            child: Center(
              child: SvgPicture.asset(
                dropDownState
                    ? xx
                        ? "svg/arrow_down_svg.svg"
                        : "svg/arrow.svg"
                    : "svg/arrow.svg",
                color: AppColors.textFormUnderLineColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPercentageRow(String percentageChanges, bool trueFalsex) {
    return Row(
      children: [
        SvgPicture.asset(
          trueFalsex ? "svg/Polygon.svg" : "svg/UnPolygon.svg",
          color: trueFalsex
              ? AppColors.truePercentageColor
              : AppColors.SignInColorGradientStart,
        ),
        SizedBox(
          width: 1.44.w,
        ),
        Text(
          percentageChanges,
          style: TextStyle(
            color: trueFalsex
                ? AppColors.truePercentageColor
                : AppColors.SignInColorGradientStart,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(11),
          ),
        ),
      ],
    );
  }

  Text buildBalance(String balanceList) {
    return Text(
      balanceList,
      style: TextStyle(
        color: AppColors.headerColor,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(12),
      ),
    );
  }
}
