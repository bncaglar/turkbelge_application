import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class HomePageHalfUpColumn extends StatefulWidget {
  @override
  _HomePageHalfUpColumnState createState() => _HomePageHalfUpColumnState();
}

class _HomePageHalfUpColumnState extends State<HomePageHalfUpColumn> {
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

  SingleChildScrollView buildBodyColumn() {
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
            Padding(
              padding: EdgeInsets.only(
                left: 7.72.w, right: 7.72.w
              ),
              child: Row(
                children: [
                  buildColumnChart(),
                  Spacer(),
                  buildCurrencyController()
                ],
              ),
            ),
            SizedBox(height: 0.86.h,),
            buildRevenueText(),
            Spacer(),
            buildChartRow(),
          ],
        ),
      ),
    );
  }

  Container buildColumnChart(){
    return   Container(
      height: 24.18.h,
      width: 75.w,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<Sum, String>>[

          ColumnSeries<Sum, String>(
            spacing: 1.7,
            color: AppColors.chartColorGreen,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            dataSource: <Sum>[
                Sum("Ocak", 44000, 5000),
                Sum("Şubat", 42000,300),
                Sum("Mart", 82000, 562),
                Sum("Nisan", 63000, 451),
                Sum("Mayıs", 58000,250),
              ],
              xValueMapper: (Sum sales, _) => sales.year,
              yValueMapper: (Sum sales, _) => sales.sales,
          ),
          ColumnSeries<Sum, String>(
            spacing: 1.7,
            color: AppColors.chartColorReddish,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            dataSource: <Sum>[
              Sum("Ocak", 350, 60000),
              Sum("Şubat", 280, 35000),
              Sum("Mart", 340, 72000),
              Sum("Nisan", 320, 28000),
              Sum("Mayıs", 400,20000),
            ],
            xValueMapper: (Sum sales, _) => sales.year,
            yValueMapper: (Sum sales, _) => sales.revenue,
          ),
        ],
      ),
    );
  }
  Padding buildRevenueText(){
    return Padding(
      padding: EdgeInsets.only(
        left: 7.72.w
      ),
      child: Column(
        children: <Widget>[
          buildRevenueRow(AppColors.chartColorReddish, "Toplam Gider"),
          buildRevenueRow(AppColors.chartColorGreen, "Toplam Gelir")
        ],
      ),
    );
  }

  Row buildRevenueRow(Color color, String text){
    return Row(
      children: <Widget>[
        buildRoundedCircle(color),
        SizedBox(width: 1.69.w,),
        buildRevenueTxt(text),      ],
    );
  }

  Text buildRevenueTxt(String text){
    return Text(
        text,
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(9),
          color: AppColors.headerBelowColor
      ),
    );
  }

  Container buildRoundedCircle(Color color){
    return Container(
      height: 1.35.h,
      width: 2.41.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
          buildCompanyName(),
          buildIcon()
        ],
      ),
    );
  }

  Align buildCompanyName() {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "İleka Akademi A.Ş.",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(13),
          color: AppColors.infoContentDialogColor,
        ),
        textAlign: TextAlign.left,
      ),
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
          buildIconButton("svg/mid_chart.svg", AppColors.textFormUnderLineColor,
              onClickPie),
          SizedBox(
            width: 5.24.w,
          ),
          buildStraightAlign(),
          SizedBox(
            width: 5.64.w,
          ),
          buildIconButton("svg/SmChart.svg", AppColors.SignInColorGradientStart,
              onClickColumn)
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
}

class Sum {
  Sum(this.year, this.sales, this.revenue);

  final String year;
  final double sales;
  final double revenue;
}
