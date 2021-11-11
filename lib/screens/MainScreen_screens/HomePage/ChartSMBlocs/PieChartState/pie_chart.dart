import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/PieChartState/pie_chart_customer_painter.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  @override
  Widget build(BuildContext context) {
    return buildGroupCompany();
  }

  Future getAllAvailableBalance(String sessionId) async {
    while(true){
      try {
        var getBalance = await WsdlRequest().getAccountInfo("ALL",sessionId);
        Map mapValue = Map<String, dynamic>.from(getBalance);
        if(mapValue["Account"] != null){
          if(mapValue["Account"].runtimeType == List){
            int? numberOfAcc = mapValue["Account"].length;
            double balance = 0;
            for (int i = 0; i < numberOfAcc!; i++) {
              balance =
                  balance + double.parse(mapValue["Account"][i]["AvailableBalance"]);
            }
          }else{
            int? numberOfAcc = 1;
            double balance = 0;
            for (int i = 0; i < numberOfAcc; i++) {
              balance =
                  balance + double.parse(mapValue["Account"]["AvailableBalance"]);
            }
          }
          return mapValue;
        }
      } catch (e) {
      print(e.toString());
      }
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
        return buildTotalBalanceBuilder("TRY", sessionId);
      } else if (state is CurrencySMEUR) {
        return buildTotalBalanceBuilder("EUR",sessionId);
      } else if (state is CurrencySMUSD) {
        return buildTotalBalanceBuilder("USD",sessionId);
      }
      return Container();
    });
  }

  FutureBuilder buildTotalBalanceBuilder(String currency, String sessionId) {
    return FutureBuilder(
      future: getAllAvailableBalance(sessionId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
            color: AppColors.textFormUnderLineColor,
          ),),);
        }
        var getData = snapshot.data;
        try {
          List categories = [];
        if(getData["Account"].runtimeType == List){
          for (int i = 0; i < getData["Account"].length; i++) {
            if (getData["Account"][i]["CurrencyType"] == currency) {
              categories.addAll([
                {
                  "bankCode": getData["Account"][i]["BankCode"],
                  "amount":
                  double.parse(getData["Account"][i]["AvailableBalance"]),
                }
              ]);
            }
          }
        }else{
          for (int i = 0; i < 1; i++) {
            if (getData["Account"]["CurrencyType"] == currency) {
              categories.addAll([
                {
                  "bankCode": getData["Account"]["BankCode"],
                  "amount":
                  double.parse(getData["Account"]["AvailableBalance"]),
                }
              ]);
            }
          }
        }
          double balance = 0;
         if(getData["Account"].runtimeType == List){
           for (int i = 0; i < getData["Account"].length; i++) {
             if (getData["Account"][i]["CurrencyType"] == currency) {
               balance = balance +
                   double.parse(getData["Account"][i]["AvailableBalance"]);
             }
           }
         }else{
           for (int i = 0; i < 1; i++) {
             if (getData["Account"]["CurrencyType"] == currency) {
               balance = balance +
                   double.parse(getData["Account"]["AvailableBalance"]);
             }
           }
         }
          String totalAccBalance = balance.toString();
          return buildLayout(categories, totalAccBalance, currency);
        } catch (e) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.textFormUnderLineColor,
              ),
            ),
          );
        }
      },
    );
  }

  LayoutBuilder buildLayout(categories, totalAccBalance, getCurrency) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.primaryWightColor,
              shape: BoxShape.circle,
              boxShadow: AppColors.neumorpShadow),
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.6,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChartCustomPainter(
                        width: constraint.maxWidth * 0.4,
                        categories: categories),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 16.h,
                  width: constraint.maxWidth * .56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.17),
                        spreadRadius: 3,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 13.h,
                  width: constraint.maxWidth * .56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.35),
                        spreadRadius: 5,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 16.h,
                  width: constraint.maxWidth * .56,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bakiye",
                          style: TextStyle(
                              color: AppColors.headerColor,
                              fontWeight: FontWeight.w600,
                              fontSize: LocalHelper.getFontSize(10)),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            totalAmount(totalAccBalance, getCurrency),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row totalAmount(totalAmountOfBalance, getCurrency) {
    return Row(
      children: [
        Text(
          oCcy.format(double.parse(totalAmountOfBalance)),
          style: TextStyle(
            color: AppColors.piechartBalanceColor,
            fontWeight: FontWeight.w600,
            fontSize: LocalHelper.getFontSize(11),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          LocalHelper.getCurrencyMethod(getCurrency),
          style: TextStyle(
              color: AppColors.piechartBalanceColor,
              fontWeight: FontWeight.w600,
              fontSize: LocalHelper.getFontSize(11)),
        ),
      ],
    );
  }
}
