import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'homepage_half_down_transition.dart';

class HomePageHalfDownPie extends StatefulWidget {
  @override
  _HomePageHalfDownPieState createState() => _HomePageHalfDownPieState();
}

class _HomePageHalfDownPieState extends State<HomePageHalfDownPie> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      child: buildGroupCompany(),
    );
  }

  Future getAllAccountInfoMethod(String sessionId) async {
    while (true) {
      try {
        var getBalance = await WsdlRequest().getAccountInfo("ALL", sessionId);
        Map mapValue = Map<String, dynamic>.from(getBalance);
        if (mapValue["Account"] != null) {
          return mapValue;
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  BlocBuilder buildCurrencyBloc(getData) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
      if (state is CurrencySmInitial) {
        return numberOfAcc(getData, "TRY") == 0
            ? Scaffold(
                body: Center(
                  child: Text(
                    "Hesap bilgisi bulunamadı!",
                    style: TextStyle(
                      color: AppColors.secondaryGrayColor,
                      fontSize: LocalHelper.getFontSize(14),
                    ),
                  ),
                ),
              )
            : buildListView(getData, "TRY");
      } else if (state is CurrencySMEUR) {
        return numberOfAcc(getData, "EUR") == 0
            ? Scaffold(
                body: Center(
                  child: Text(
                    "Hesap bilgisi bulunamadı!",
                    style: TextStyle(
                      color: AppColors.secondaryGrayColor,
                      fontSize: LocalHelper.getFontSize(14),
                    ),
                  ),
                ),
              )
            : buildListView(getData, "EUR");
      } else if (state is CurrencySMUSD) {
        return numberOfAcc(getData, "USD") == 0
            ? Scaffold(
                body: Center(
                  child: Text(
                    "Hesap bilgisi bulunamadı!",
                    style: TextStyle(
                      color: AppColors.secondaryGrayColor,
                      fontSize: LocalHelper.getFontSize(14),
                    ),
                  ),
                ),
              )
            : buildListView(getData, "USD");
      }
      return Container();
    });
  }

  numberOfAcc(getData, String currency) {
    try {
      List listOfAcc = [];
      int accNo = 1;
      if (getData["Account"].runtimeType == List) {
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            listOfAcc.addAll([
              {
                "bankCode": getData["Account"][i]["BankCode"],
              }
            ]);
          }
          accNo = listOfAcc.length;
        }
      }
      return accNo;
    } catch (e) {
      log.i(e.toString());
    }
  }

  BlocBuilder buildGroupCompany() {
    return BlocBuilder<DropdownCubit, DropdownState>(builder: (context, state) {
      if (state is DropdownInitial) {
        return getAllAccountInfoMethodBuilder("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
      } else if (state is DropdownSecondCompany) {
        return getAllAccountInfoMethodBuilder("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
      }
      return Container();
    });
  }

  FutureBuilder getAllAccountInfoMethodBuilder(String sessionId) {
    return FutureBuilder(
        future: getAllAccountInfoMethod(sessionId),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                return HomePagePieChartStateTransition(isPie: false);
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
                  return HomePagePieChartStateTransition(isPie: false);
                }
              }
              return buildCurrencyBloc(snapshot.data);
          }
        });
  }

  ListView buildListView(getData, String currency) {
    List list = [];

    return ListView.builder(
      padding: EdgeInsets.only(top: 2.71.h),
      itemCount: getData["Account"].runtimeType == List
          ? getData["Account"].length
          : 1,
      itemBuilder: (context, index) {
        if (getData["Account"].runtimeType == List) {
          final bankCode = getData["Account"][index]["BankCode"];
          final getCurrency = getData["Account"][index]["CurrencyType"];
          final balanceList = buildTotalBalance(getData, bankCode, currency);
          double balance = 0;
          for (int i = 0; i < getData["Account"].length; i++) {
            if (getData["Account"][i]["CurrencyType"] == currency) {
              balance = balance +
                  double.parse(getData["Account"][i]["AvailableBalance"]);
            }
          }
          int numberOfAcc = numberOfAccMethod(getData, bankCode, currency);
          final colorList = AppColors.pieColors[index];
          if (getCurrency == currency) {
            for(int i = 0; i<getData["Account"].length; i++){
              if(!list.contains(getData["Account"][i]["BankCode"])){
                if(getCurrency == currency){
                  list.add(getData["Account"][i]["BankCode"]);
                  log.i(list);
                  if(list.contains(getData["Account"][i]["BankCode"])){
                    return buildEachBankRow(bankCode, numberOfAcc, balanceList,
                        colorList, getCurrency, balance, currency);
                  }
                }
              }
            }
            return Container();
          } else {
            return Container();
          }
        } else {
          final bankCode = getData["Account"]["BankCode"];
          final getCurrency = getData["Account"]["CurrencyType"];

          final balanceList = buildTotalBalance(getData, bankCode, currency);
          double balance = 0;
          if (getCurrency == currency) {
            balance = balance +
                double.parse(getData["Account"][index]["AvailableBalance"]);
          }
          int numberOfAcc = numberOfAccMethod(getData, bankCode, currency);
          final colorList = AppColors.pieColors[index];
          if (getCurrency == currency) {
            return buildEachBankRow(bankCode, numberOfAcc, balanceList,
                colorList, getCurrency, balance, currency);
          } else {
            return Container();
          }
        }
      },
    );
  }

  String buildTotalBalance(getData, bankCode, currency) {
    try {
      List listOfAcc = [];
      double listOfBalance = 0;
      if (getData["Account"].runtimeType == List) {
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            listOfAcc.addAll([
              {
                "bankCode": getData["Account"][i]["BankCode"],
              }
            ]);
            if (listOfAcc.length > 1) {
              if (listOfAcc[i]["bankCode"] == bankCode) {
                listOfBalance +=
                    double.parse(getData["Account"][i]["AvailableBalance"]);
              }
            } else {
              if (listOfAcc[0]["bankCode"] == bankCode) {
                listOfBalance +=
                    double.parse(getData["Account"][i]["AvailableBalance"]);
              }
            }
          }
        }
      } else {}
      return listOfBalance.toString();
    } catch (e) {
      return "0";
    }
  }

  int numberOfAccMethod(getData, bankCode, currency) {
    try {
      int accNo = 0;
      if (getData["Account"].runtimeType == List) {
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            if (getData["Account"][i]["BankCode"] == bankCode) {
              accNo += 1;
            }
          }
        }
      } else {
        accNo = 1;
      }
      return accNo;
    } catch (e) {
      return 0;
    }
  }

  Padding buildEachBankRow(String bankCode, int listofAccountList,
      String balanceList, Color color, getCurrency, balance, currencyBloc) {
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w),
      child: Container(
        height: 7.20.h,
        color: AppColors.primaryWightColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBankAccountRow(
                  color,
                  bankCode,
                  listofAccountList,
                ),
                buildPercentage(
                    balanceList, balance, getCurrency, currencyBloc),
                Spacer(),
                buildAccountBalance(balanceList, getCurrency),
              ],
            ),
            Container(
              height: 1,
              width: 84.54.w,
              color: AppColors.textFormUnderLineColor,
            )
          ],
        ),
      ),
    );
  }

  Row buildBankAccountRow(
    Color color,
    String bankCode,
    int listofAccountList,
  ) {
    return Row(
      children: <Widget>[
        buildBankColor(color),
        buildBankInfoColumn(bankCode, listofAccountList)
      ],
    );
  }

  Column buildBankInfoColumn(String bankCode, int numberOfAcc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalHelper.getBankName(bankCode),
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(13),
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 1.h,
          width: 42.43.w,
        ),
        Text(
          "$numberOfAcc Hesap",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(10),
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Padding buildBankColor(Color color) {
    return Padding(
      padding: EdgeInsets.only(right: 2.17.w, bottom: 1.15.h, top: 1.15.h),
      child: Container(
        height: 4.75.h,
        width: 1.44.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  Text buildPercentage(balanceList, balance, getCurrency, currency) {
    String percentageValue =
        calculatePercentage(balanceList, balance, getCurrency, currency)
            .toString();
    return Text(
      "${percentageValue.substring(0, percentageValue.length < 5 ? percentageValue.length : 5)}%",
      style: TextStyle(
        color: AppColors.icon_color,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(11),
      ),
    );
  }

  double calculatePercentage(value, total, getCurrency, currency) {
    double valueDouble = double.parse(value);
    double percentage = (valueDouble * 100) / total;
    return percentage;
  }

  Row buildAccountBalance(String balanceList, getCurrency) {
    return Row(
      children: [
        Text(
          oCcy.format(double.parse(balanceList)),
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(13),
          ),
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          LocalHelper.getCurrencyMethod(getCurrency),
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(13),
          ),
        )
      ],
    );
  }
}
