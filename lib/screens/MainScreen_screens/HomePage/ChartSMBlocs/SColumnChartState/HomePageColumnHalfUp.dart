import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/logic/filter_sm/filter_sm_cubit.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class HomePageHalfUpColumn extends StatefulWidget {
  @override
  _HomePageHalfUpColumnState createState() => _HomePageHalfUpColumnState();
}

class _HomePageHalfUpColumnState extends State<HomePageHalfUpColumn> {
  Color selectedCurrencyColor = AppColors.SignInColorGradientStart;
  Color unselectedCurrencyColor = AppColors.infoContentDialogColor;
  List<String> items = [
    "İleka Akademi A.Ş.".toUpperCase(),
    'İleka Telekominikasyon A.Ş.'.toUpperCase(),
  ];
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
                  buildGroupCompany(),
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


  Container buildColumnChart(getData, String filterValue, bool isTransition,String currency){
    return Container(
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
            dataSource: getData == "null" ? isTransition ? <Sum>[
            ]: buildSumGelirList(getData,filterValue,currency) :  buildSumGelirList(getData,filterValue,currency),
              xValueMapper: (Sum sales, _) => sales.year,
              yValueMapper: (Sum sales, _) => sales.sales,
          ),
          ColumnSeries<Sum, String>(
            spacing: 1.7,
            color: AppColors.chartColorReddish,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            dataSource: getData == "null" ? isTransition ? <Sum>[

            ] : buildSumGiderList(getData,filterValue,currency) : buildSumGiderList(getData,filterValue,currency),
            xValueMapper: (Sum sales, _) => sales.year,
            yValueMapper: (Sum sales, _) => sales.revenue,
          ),
        ],
      ),
    );
  }

  String returnDayToString(String value){
    switch(value){
      case "1":{
        return "Pazar";
      }
      case "2":{
        return "Pztesi";
      }
      case "3":{
        return "Salı";
      }
      case "4":{
        return "Çarş";
      }
      case "5":{
        return "Perş";
      }
      case "6":{
        return "Cuma";
      }
      case "7":{
        return "Ctesi";
      }
    }
    return "";
  }

  String returnMonthToString(String value){
    switch(value){
      case "1":{
        return "Ocak";
      }
      case "2":{
        return "Şubat";
      }
      case "3":{
        return "Mart";
      }
      case "4":{
        return "Nisan";
      }
      case "5":{
        return "Mayis";
      }
      case "6":{
        return "Haziran";
      }
      case "7":{
        return "Temmuz";
      }
      case "8":{
        return "Ağustos";
      }
      case "9":{
        return "Eylül";
      }
      case "10":{
        return "Ekim";
      }
      case "11":{
        return "Kasım";
      }
      case "12":{
        return "Aralık";
      }
    }
    return "";
  }

  List<Sum> buildSumGiderList(getData, String filterValue,String currency){
   try{
     int numberOfValue = getData["TransactionStatistics"].length;
     final log = Logger();
     List<Sum>? sumList = [];
     switch(filterValue){
       case "ONE":{
         for(int i = 0; i<numberOfValue; i++){
           if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
             if(getData["TransactionStatistics"][i]["BorcAlacak"] == "B"){
               String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
               double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
               sumList.add(
                   Sum(identifierName, 0, totalAmount)
               );
             }
           }
         }
         return sumList;
       }
       case "WEEK":{
         for(int i = 0; i<numberOfValue; i++){
           if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
             if(getData["TransactionStatistics"][i]["BorcAlacak"] == "B"){
               String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
               double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
               sumList.add(
                   Sum(returnDayToString(identifierName), 0, totalAmount)
               );
             }
           }
         }
         return sumList;
       }
       case "MONTH":{
         for(int i = 0; i<numberOfValue; i++){
           if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
             if(getData["TransactionStatistics"][i]["BorcAlacak"] == "B"){
               String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
               double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
               sumList.add(
                   Sum(identifierName, 0, totalAmount)
               );
             }
           }
         }
         return sumList;
       }
       case "YEAR":{
         for(int i = 0; i<numberOfValue; i++){
           if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
             if(getData["TransactionStatistics"][i]["BorcAlacak"] == "B"){
               String identifierName = returnMonthToString(getData["TransactionStatistics"][i]["Identifier"].toString());
               double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
               sumList.add(
                   Sum(identifierName, 0, totalAmount)
               );
             }
           }
         }
         return sumList;
       }
     }
     return sumList;
   }catch(e){
     List<Sum>? sumList = [];
    return sumList;
   }
  }

  List<Sum> buildSumGelirList(getData, String filterValue, String currency){
   try{
     List<Sum>? sumList = [];
     if(getData != null){
       int numberOfValue = getData["TransactionStatistics"].length;
       switch(filterValue){
         case "ONE":{
           for(int i = 0; i<numberOfValue; i++){
             if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
               if(getData["TransactionStatistics"][i]["BorcAlacak"] == "A"){
                 String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
                 double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
                 sumList.add(
                     Sum(identifierName, totalAmount, 0)
                 );
               }
             }
           }
           return sumList;
         }
         case "WEEK":{
           for(int i = 0; i<numberOfValue; i++){
             if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
               if(getData["TransactionStatistics"][i]["BorcAlacak"] == "A"){
                 String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
                 double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
                 sumList.add(
                     Sum(returnDayToString(identifierName), totalAmount, 0)
                 );
               }
             }
           }
           return sumList;
         }
         case "MONTH":{
           for(int i = 0; i<numberOfValue; i++){
             if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
               if(getData["TransactionStatistics"][i]["BorcAlacak"] == "A"){
                 String identifierName = getData["TransactionStatistics"][i]["Identifier"].toString();
                 double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
                 sumList.add(
                     Sum(identifierName, totalAmount, 0)
                 );
               }
             }
           }
           return sumList;
         }
         case "YEAR":{
           for(int i = 0; i<numberOfValue; i++){
             if(getData["TransactionStatistics"][i]["CurrencyType"] == currency){
               if(getData["TransactionStatistics"][i]["BorcAlacak"] == "A"){
                 String identifierName = returnMonthToString(getData["TransactionStatistics"][i]["Identifier"].toString());
                 double totalAmount =  double.parse(getData["TransactionStatistics"][i]["Amount"]);
                 sumList.add(
                     Sum(identifierName, totalAmount, 0)
                 );
               }
             }
           }
           return sumList;
         }
         default:{

         }
       }

       return sumList;
     }else{
       return sumList;
     }
   }catch(e){
     List<Sum>? sumList = [];
     return sumList;
   }
  }

  BlocBuilder buildGroupCompany(){
    return BlocBuilder<DropdownCubit, DropdownState>(
        builder: (context, state){
          if(state is DropdownInitial){
            return buildCurrencyBloc("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
          }else if(state is DropdownSecondCompany){
            return buildCurrencyBloc("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
          }
          return Container();
        }
    );
  }

  BlocBuilder buildCurrencyBloc(String sessionId) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
          if (state is CurrencySmInitial) {
            print("State: $CurrencySmInitial");
            return buildTimeZoneBloc("TRY",sessionId);
          } else if (state is CurrencySMEUR) {
            return buildTimeZoneBloc("EUR",sessionId);
          } else if (state is CurrencySMUSD) {
            return buildTimeZoneBloc("USD",sessionId);
          }
          return Container();
        });
  }

  BlocBuilder buildTimeZoneBloc(String currency, String sessionId){
    DateTime endDate = DateTime.now();
    String endDateString = endDate.toString().substring(0, 10);
    return BlocBuilder<FilterSmCubit, FilterSmState>(
        builder: (context, state){
          if(state is FilterSmOneDay){
            DateTime startDate = endDate.subtract(const Duration(days: 1));
            String startDateString = startDate.toString().substring(0, 10);
            print(startDateString);
            return buildGetTransactionStatisticsFuture(startDateString, endDateString, sessionId, "DAY",currency);
          }else if(state is FilterSmOneWeek){
            DateTime startDate = endDate.subtract(const Duration(days: 7));
            String startDateString = startDate.toString().substring(0, 10);
            return buildGetTransactionStatisticsFuture(startDateString, endDateString, sessionId, "WEEK",currency);
          }else if(state is FilterSmOneMonth){
            DateTime startDate = endDate.subtract(const Duration(days: 30));
            String startDateString = startDate.toString().substring(0, 10);
            return buildGetTransactionStatisticsFuture(startDateString, endDateString, sessionId, "MONTH",currency);
          }else if(state is FilterSmOneYear){
            DateTime startDate = endDate.subtract(const Duration(days: 365));
            String startDateString = startDate.toString().substring(0, 10);
            return buildGetTransactionStatisticsFuture(startDateString, endDateString, sessionId, "YEAR",currency);
          }
          return Container();
        }
    );
  }

  FutureBuilder buildGetTransactionStatisticsFuture(String startDate, String endDate, String sessionId, String filterValue, String currency){
    return FutureBuilder(
      future: getTransactionStatistics(startDate, endDate, sessionId),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:{
            return buildColumnChart(snapshot.data,filterValue, true, currency);
          }
          case ConnectionState.active:{
            return buildColumnChart(snapshot.data,filterValue, true, currency);
          }
          default:
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return buildColumnChart(snapshot.data,filterValue,false, currency);
                ///todo return the widget
              }else if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textFormUnderLineColor,
                    ),
                  ),
                );
              }
            }
            print(snapshot.data);
            return buildColumnChart(snapshot.data,filterValue,false, currency);
            ///todo return the widget
        }
      },
    );
  }

   Future getTransactionStatistics(String startDate, String endDate, String sessionId)async{
    while(true){
      try{
        var getStatistics = await WsdlRequest().getStatisticsTransaction(startDate, endDate, "ALL", sessionId);
        Map mapValue = Map<String, dynamic>.from(getStatistics);
        if(mapValue["TransactionStatistics"] != null){
          return mapValue;
        }
      }catch(e){
        print(e.toString());
        return "null";
      }
    }
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
          buildGroupCompanyName(),
          buildIcon()
        ],
      ),
    );
  }
  BlocBuilder buildGroupCompanyName(){
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

  Align buildCompanyName() {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "İleka Akademi A.Ş.".toUpperCase(),
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
