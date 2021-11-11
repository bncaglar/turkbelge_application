import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/drop_down_menu.dart';

class HomePageHalfUp extends StatefulWidget {
  @override
  _HomePageHalfUpState createState() => _HomePageHalfUpState();
}

class _HomePageHalfUpState extends State<HomePageHalfUp> {
  final log = Logger();
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
  List _testList = [{'no': 1, 'keyword': 'blue'},{'no': 2, 'keyword': 'black'},{'no': 3, 'keyword': 'red'}];

  Color selectedCurrencyColor = AppColors.SignInColorGradientStart;
  Color unselectedCurrencyColor = AppColors.infoContentDialogColor;

  onClickTL() {
    context.read<CurrencySmCubit>().changeCurrencyState(CurrencySmInitial());
    //context.read<GroupCompanySmCubit>().changeCompany(GroupCompanySmFirstx());

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


  Future getAllAvailableBalance(String sessionID) async {
     while(true){
       try {
         var getBalance = await WsdlRequest().getAccountInfo("ALL",sessionID);
         if(getBalance == "null"){
           return getBalance;
         }else{
           Map mapValue = Map<String, dynamic>.from(getBalance);
           if(mapValue["Account"] != null){
             return mapValue;
           }
         }
       } catch (e) {
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return buildHalfScreenUp();
  }

  Stack buildHalfScreenUp() {
    return Stack(
      children: [
        buildBackgroundImage(),
        buildBodyColumn(),
      ],
    );
  }

  Container buildBackgroundImage() {
    return Container(
      height: 43.47.h,
      width: double.infinity,
      child: Image.asset(
        "assets/red_background.png",
        fit: BoxFit.fill,
      ),
    );
  }

  SingleChildScrollView buildBodyColumn() {
    return SingleChildScrollView(
      child: Container(
        height: 43.47.h,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
                height:8.h,
                child: DropDownDemo()),
            buildStraightLine(),
            buildBalanceRow(),
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
        "İleka Akademi A.Ş.".toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(13),
          color: AppColors.primaryWightColor,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Container buildIcon() {
    return Container(
      height: 2.71.h,
      width: 1.w,
      child: Icon(
        Icons.arrow_drop_down,
        color: AppColors.primaryWightColor,
      ),
    );
  }

  Padding buildStraightLine() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.84.h),
      child: Container(
        height: 0.135.h,
        width: 84.54.w,
        color: AppColors.homepageStraightLineColor,
      ),
    );
  }

  Padding buildBalanceRow() {
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
          buildBalance(),
          buildCurrencyController(),
        ],
      ),
    );
  }

  Column buildBalance() {
    return Column(
      children: [
        Text(
          "Bakiye",
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(15),
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 1.h,
        ),
        buildGroupCompany(),
      ],
    );
  }

  FutureBuilder buildTotalBalanceBuilder(String currency,sessionId) {
    return FutureBuilder(
      future: getAllAvailableBalance(sessionId),
      builder: (BuildContext context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:{
            return CircularProgressIndicator(
                     color: AppColors.primaryWightColor,
            );
          }
          case ConnectionState.active:{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryWightColor,
                ),
              ),
            );
          }
          default:
            if(snapshot.data == "null"){
              return Container();
            }else{
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  return buildBalanceWidget(snapshot.data,currency);
                }else if(snapshot.hasError){
                  print(snapshot.error);
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryWightColor,
                      ),
                    ),
                  );
                }
              }
            }
            return buildBalanceWidget(snapshot.data,currency);

        }
      },
    );
  }

  Widget buildBalanceWidget(getData, String currency){
    double balance = 0;
    int numberOfAcc = 0;
   if(getData["Account"].runtimeType == List){
     numberOfAcc = numberOfAccMethod(getData, currency);
     for (int i = 0; i < getData["Account"].length; i++) {
         if(getData["Account"][i]["CurrencyType"] == currency){
           balance =
               balance + double.parse(getData["Account"][i]["AvailableBalance"]);
         }
     }
   }else{
     print("xcd");
     numberOfAcc = 1;
     for (int i = 0; i < numberOfAcc; i++) {
       if (getData["Account"]["CurrencyType"] == currency) {
         balance =
             balance + double.parse(getData["Account"]["AvailableBalance"]);
       }
     }
   }
    int numberOfBank = 0;

    if(getData["Account"].runtimeType == List){
      numberOfBank = numberOfBankMethod(getData, currency);
    }else{
      numberOfBank = 1;
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              oCcy.format(balance),
              style: TextStyle(
                  color: AppColors.primaryWightColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(29),
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              LocalHelper.getCurrencyMethod(currency),
              style: TextStyle(
                  color: AppColors.primaryWightColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(29),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        buildTotalAccountAndBanksRow(numberOfBank, numberOfAcc),
      ],
    );
  }

  int numberOfAccMethod(getData,String currency) {
    try{
      List listOfAcc = [];
      int accNo = 0;
      if(getData["Account"].runtimeType == List){
        for (int i = 0; i < getData["Account"].length; i++) {
          if(getData["Account"][i]["CurrencyType"] == currency){
            listOfAcc.addAll([
              {
                "bankCode": getData["Account"][i]["BankCode"],
              }
            ]);
          }
          accNo = listOfAcc.length;
        }
      }else{
        accNo = 1;
      }
      return accNo;
    }catch(e){
      return 0;
    }
  }

  int numberOfBankMethod(getData,String currency) {
   try{
     List listOfAcc = [];
     int accNo = 0;
     if(getData["Account"].runtimeType == List){
       for (int i = 0; i < getData["Account"].length; i++) {
         if(getData["Account"][i]["CurrencyType"] == currency){
           listOfAcc.addAll([
             {
               "bankCode": getData["Account"][i]["BankCode"],
             }
           ]);
           accNo = listOfAcc.length;
         }
         if(accNo != 1){
           if(getData["Account"][i]["CurrencyType"] == currency){
             if (listOfAcc[i]["bankCode"] == getData["Account"][i]["BankCode"]) {
               accNo += -1;
             }
           }
         }
       }
     }else{
       accNo = 1;
     }
     return accNo;
   }catch(e){
     log.i(e.toString());
     return 0;
   }
  }

  Row buildTotalBalance(String first, String second, String currency) {
    return Row(
      children: [
        NumberSlideAnimation(
          number: first,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutQuad,
          textStyle: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
        Text(
          ",",
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
        NumberSlideAnimation(
          number: second,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutQuad,
          textStyle: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
        Text(
          ".",
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
        NumberSlideAnimation(
          number: "00",
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutQuad,
          textStyle: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
        Text(
          currency,
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(29),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  } //TODO

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
        return buildTotalBalanceBuilder("TRY",sessionId);
      } else if (state is CurrencySMEUR) {
        return buildTotalBalanceBuilder("EUR",sessionId);
      } else if (state is CurrencySMUSD) {
        return buildTotalBalanceBuilder("USD",sessionId);
      }
      return Container();
    });
  }

  Container buildTotalAccountAndBanksRow(numberOfBank, numberOfAcc) {
    return Container(
      width: 37.68.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildAccountsColumns(numberOfAcc),
          buildHorizontalLine(),
          buildBanksColumn(numberOfBank)
        ],
      ),
    );
  }

  Column buildAccountsColumns(numberOfAcc) {
    return Column(
      children: [
        Text(
          "Hesaplar",
          style: TextStyle(
            color: AppColors.accountsColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        //TODO hesaplar
        Text(
          numberOfAcc.toString(),
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(14),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Container buildHorizontalLine() {
    return Container(
      height: 4.66.h,
      width: 1,
      color: AppColors.accountsAndBankStraightLine,
    );
  }

  Column buildBanksColumn(numberOfBank) {
    return Column(
      children: [
        Text(
          "Bankalar",
          style: TextStyle(
            color: AppColors.accountsColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          numberOfBank.toString(),
          style: TextStyle(
              color: AppColors.primaryWightColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(14),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Container buildCurrencyController() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: AppColors.primaryWightColor),
        width: 8.21.w,
        height: 18.20.h,
        child: buildCurrencyColorBloc());
  }

  InkWell buildCurrency(VoidCallback onTap, String label, Color color) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 5.95.h,
        width: 8.21.w,
        child: Center(
          child: Text(
            label,
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
              "svg/list.svg", AppColors.primaryWightColor, onClickChart),
          SizedBox(
            width: 5.88.w,
          ),
          buildStraightAlign(),
          SizedBox(
            width: 4.78.w,
          ),
          buildIconButton(
              "svg/mid_chart.svg", AppColors.accountsColor, onClickPie),
          SizedBox(
            width: 5.24.w,
          ),
          buildStraightAlign(),
          SizedBox(
            width: 5.64.w,
          ),
          buildIconButton(
              "svg/SmChart.svg", AppColors.accountsColor, onClickColumn)
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
