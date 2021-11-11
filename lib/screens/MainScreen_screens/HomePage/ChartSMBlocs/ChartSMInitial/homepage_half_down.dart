import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/PieChartState/homepage_half_down_transition.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/bank_details/bank_details_new/bank_details_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/transition_page.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/throwErrorBtn.dart';

class HomePageHalfDown extends StatefulWidget {
  @override
  _HomePageHalfDownState createState() => _HomePageHalfDownState();
}

class _HomePageHalfDownState extends State<HomePageHalfDown> {
  final log = Logger();
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  onClickBank(String bankCode) {
    log.i("onClickBank started");
    Navigator.pushNamed(context, BankDetailsNew.routeName,
        arguments: BankDetailsNewArguments(bankCode: bankCode));
  }

  ///todo

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      child: buildGroupCompany(),
    );
  }

  Future getAccountInfoMethod(String sessionId) async {
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

  BlocBuilder buildGroupCompany() {
    return BlocBuilder<DropdownCubit, DropdownState>(builder: (context, state) {
      if (state is DropdownInitial) {
        return buildGetAccountInfoMethodBuilder(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
      } else if (state is DropdownSecondCompany) {
        return buildGetAccountInfoMethodBuilder(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
      }
      return Container();
    });
  }

  FutureBuilder buildGetAccountInfoMethodBuilder(String sessionId) {
    return FutureBuilder(
      future: getAccountInfoMethod(sessionId),
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

                return throwErrorWidget();
              }
            }
            return buildCurrencyBloc(snapshot.data);
        }
      },
    );
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

  BlocBuilder buildCurrencyBloc(getData) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
      if (state is CurrencySmInitial) {
        return buildListView(getData, "TRY");
      } else if (state is CurrencySMEUR) {
        return buildListView(getData, "EUR");
      } else if (state is CurrencySMUSD) {
        return buildListView(getData, "USD");
      }
      return Container();
    });
  }

  numberOfAcc(getData, String currency) {
    ///todo we changed it
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

  getCurrencyMethod(currency, index, getData) {
    List list = [];
    print(index);
    for (int i = 0; i < getData["Account"].length; i++) {
      if (getData["Account"][i]["CurrencyType"] == currency) {
        list.addAll([
          {"xd": currency}
        ]);
        print(list);
      }
    }
    log.i(list[0]["xd"]);

    return list;
  }

  ListView buildListView(getData, currency) {
    return getData["Account"].runtimeType == List
        ? ListView.builder(
            padding: EdgeInsets.only(top: 1.08.h),
            itemCount: getData["Account"].length,
            itemBuilder: (context, index) {
              if (getData["Account"][index]["CurrencyType"] == currency) {
                final getCurrency = getData["Account"][index]["CurrencyType"];
                final getBankCode = getData["Account"][index]["BankCode"];
                final getAccountBalance = buildTotalBalance(getData,getBankCode,currency);

                int numberOfAcc =
                    numberOfAccMethod(getData, getBankCode, currency);
                return buildEachBankRow(1, getAccountBalance, getBankCode,
                    getCurrency, numberOfAcc);
              } else {
                return Container();
              }
            },
          )
        : ListView.builder(
            padding: EdgeInsets.only(top: 1.08.h),
            itemCount: 1,
            itemBuilder: (context, index) {
              if (getData["Account"]["CurrencyType"] == currency) {
                final getCurrency = getData["Account"]["CurrencyType"];
                final getBankCode = getData["Account"]["BankCode"];
                final balanceList = buildTotalBalance(getData,getBankCode,currency);
                int numberOfAcc =
                    numberOfAccMethod(getData, getBankCode, currency);
                return buildEachBankRow(1, balanceList, getBankCode,
                    getCurrency, numberOfAcc);
              } else {
                return Container();
              }
            },
          );
  }

  String  buildTotalBalance (getData, bankCode, currency) {
    try {
      List listOfAcc = [];
      double listOfBalance = 0;
      if(getData["Account"].runtimeType == List){
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            listOfAcc.addAll([
              {
                "bankCode": getData["Account"][i]["BankCode"],
              }
            ]);
            if (listOfAcc[i]["bankCode"] == bankCode) {
              listOfBalance += double.parse(getData["Account"][i]["AvailableBalance"]);
            }
          }
        }
      }else{
      }
      print(listOfBalance);
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

  int numberOfBankMethod(getData, String currency) {
    try {
      List listOfAcc = [];
      int accNo = 0;
      if (getData["Account"].runtimeType == List) {
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            listOfAcc.addAll([
              {
                "bankCode": getData["Account"][i]["BankCode"],
              }
            ]);
            accNo = listOfAcc.length;
          }
        }
      } else {
        accNo = 1;
      }
      return accNo;
    } catch (e) {
      log.i(e.toString());
      return 0;
    }
  }

  Padding buildEachBankRow(int listofAccountList, String balanceList, bankCodes,
      getCurrency, numberOfAcc) {
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w),
      child: InkWell(
        onTap: () => onClickBank(bankCodes),
        child: Container(
          height: 7.47.h,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  buildBankLogo(bankCodes),
                  buildNumberOfAccount(numberOfAcc),
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
      ),
    );
  }

  Padding buildBankLogo(String bankCode) {
    return Padding(
      padding: EdgeInsets.only(right: 22.22.w),
      child: Column(
        children: [
          Container(
            width: 23.42.w,
            height: 7.26.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                LocalHelper.getBankLogoString(bankCode),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text buildNumberOfAccount(numberOfAcc) {
    return Text(
      "$numberOfAcc Hesap",
      style: TextStyle(
        color: AppColors.infoContentDialogColor,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(10),
      ),
    );
  }

  Row buildAccountBalance(String balanceList, String getCurrency) {
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
        ),
      ],
    );
  }
}
