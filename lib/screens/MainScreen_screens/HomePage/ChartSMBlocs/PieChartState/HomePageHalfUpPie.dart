import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/PieChartState/pie_chart.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class HomePageHalfUpPie extends StatefulWidget {
  @override
  _HomePageHalfUpPieState createState() => _HomePageHalfUpPieState();
}

class _HomePageHalfUpPieState extends State<HomePageHalfUpPie> {
  final log = Logger();
  List<String> items = [
    "İleka Akademi A.Ş.".toUpperCase(),
    'İleka Telekominikasyon A.Ş.'.toUpperCase(),
  ];
  Color selectedCurrencyColor = AppColors.SignInColorGradientStart;
  Color unselectedCurrencyColor = AppColors.infoContentDialogColor;

  onClickTL() {
    context.read<CurrencySmCubit>().changeCurrencyState(CurrencySmInitial());
  }

  onClickEUR() {
    context.read<CurrencySmCubit>().changeCurrencyState(CurrencySMEUR());
  }

  onClickUSD() {
    context.read<CurrencySmCubit>().changeCurrencyState(CurrencySMUSD());
  }

  onClickChart() {
    context.read<ChartSmCubit>().changeChartState(ChartSmInitial());
  }

  onClickPie() {
    context.read<ChartSmCubit>().changeChartState(PieChartState());
  }

  onClickColumn() {
    context.read<ChartSmCubit>().changeChartState(SColumnChartState());
  }
  @override
  Widget build(BuildContext context) {
    return buildBodyColumn();
  }

  SingleChildScrollView buildBodyColumn(){
    return SingleChildScrollView(
      child: Container(
        height: 43.34.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryWightColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.19),
              spreadRadius: 7,
              blurRadius: 7,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            buildHeaderRow(),
            buildStraightLine(),
            buildPieChartRow(),
            Spacer(),
            buildChartRow(),
          ],
        ),
      ),
    );
  }

  Padding buildHeaderRow() {
    return Padding(
      padding: EdgeInsets.only(
          right: 10.86.w, left: 10.86.w, top: 2.71.h, bottom: 1.49.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 1.w,
          ),
          buildGroupCompany(),
          buildIcon()
        ],
      ),
    );
  }

  BlocBuilder buildGroupCompany(){
    return BlocBuilder<DropdownCubit, DropdownState>(
        builder: (context, state){
          if(state is DropdownInitial){
            return Text(
              items[0].toString().trim().toUpperCase(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(13),
                color: AppColors.infoContentDialogColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            );
          }else if(state is DropdownSecondCompany){
            return Text(
              items[1].toString().trim().toUpperCase(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(13),
                color: AppColors.infoContentDialogColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            );
          }
          return Container();
        }
    );
  }

  InkWell buildIcon() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 2.71.h,
        width: 1.w,
        child: Icon(
          Icons.more_vert,
          color: AppColors.SignInColorGradientStart,
        ),
      ),
    );
  }

  Padding buildStraightLine() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.21.h),
      child: Container(
        height: 0.135.h,
        width: 84.54.w,
        color: AppColors.textFormUnderLineColor,
      ),
    );
  }

  Padding buildPieChartRow(){
    return Padding(
      padding: EdgeInsets.only(
        right: 7.72.w,
        left: 7.72.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 8.21.w,
          ),
          Container(
            height: 27.80.h,
              width: 45.66.w,
              child: PieChart(),
          ),
          buildCurrencyController(),
        ],
      ),
    );
  }

  Container buildCurrencyController() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.SignInColorGradientStart),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: AppColors.primaryWightColor),
      width: 8.21.w,
      height: 18.45.h,
      child: buildCurrencyColorBloc()
    );
  }

  BlocBuilder buildCurrencyColorBloc() {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
          if (state is CurrencySmInitial) {
            return Column(
              children: [
                buildCurrency(onClickTL, "TL", selectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickUSD, "USD", unselectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickEUR, "EUR", unselectedCurrencyColor),
              ],
            );
          } else if (state is CurrencySMEUR) {
            return Column(
              children: [
                buildCurrency(onClickTL, "TL", unselectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickUSD, "USD", unselectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickEUR, "EUR", selectedCurrencyColor),
              ],
            );
          } else if (state is CurrencySMUSD) {
            return Column(
              children: [
                buildCurrency(onClickTL, "TL", unselectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickUSD, "USD", selectedCurrencyColor),
                buildStraightCurrencyControllerLine(),
                buildCurrency(onClickEUR, "EUR", unselectedCurrencyColor),
              ],
            );
          }
          return Container();
        });
  }

  InkWell buildCurrency(VoidCallback onTap, String textLabel, Color color) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 5.95.h,
        width: 8.21.w,
        child: Center(
          child: Text(
            textLabel,
            style: TextStyle(
              color: color,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(11),
            ),
          ),
        ),
      ),
    );
  }

  Container buildStraightCurrencyControllerLine() {
    return Container(
      color: AppColors.homepageStraightLineColor,
      width: 6.13.w,
      height: 1,
    );
  }

  Padding buildChartRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.69.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildIconButton(
              "svg/list.svg", AppColors.textFormUnderLineColor, onClickChart),
          SizedBox(
            width: 5.88.w,
          ),
          buildStraightAlign(),
          SizedBox(
            width: 4.78.w,
          ),
          buildIconButton(
              "svg/mid_chart.svg", AppColors.SignInColorGradientStart, onClickPie),
          SizedBox(
            width: 5.24.w,
          ),
          buildStraightAlign(),
          SizedBox(
            width: 5.64.w,
          ),
          buildIconButton(
              "svg/SmChart.svg", AppColors.textFormUnderLineColor, onClickColumn)
        ],
      ),
    );
  }

  Container buildStraightAlign() {
    return Container(
      height: 1.57.h,
      width: 1,
      color: AppColors.accountsColor,
    );
  }

  InkWell buildIconButton(String iconPath, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: SvgPicture.asset(
          iconPath,
          color: color,
        ),
      ),
    );
  }

}
