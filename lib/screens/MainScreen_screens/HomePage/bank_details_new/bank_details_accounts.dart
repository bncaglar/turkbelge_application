import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
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

import 'bank_details_expansion_panel.dart';

class BankDetailsAllAccounts extends StatefulWidget {
  final String getBankCode;

  BankDetailsAllAccounts({required this.getBankCode});

  @override
  _BankDetailsAllAccountsState createState() => _BankDetailsAllAccountsState();
}

class _BankDetailsAllAccountsState extends State<BankDetailsAllAccounts> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
  final log = Logger();
  List<bool> expandedValueList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13.70.h * 5.5,
      padding: EdgeInsets.only(
        top: 1.90.h,
        right: 2.65.w,
        left: 2.65.w,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.13),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: buildGroupCompany(),
    );
  }

  BlocBuilder buildGroupCompany() {
    return BlocBuilder<DropdownCubit, DropdownState>(builder: (context, state) {
      if (state is DropdownInitial) {
        return addValueBeforeBuild(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
      } else if (state is DropdownSecondCompany) {
        return addValueBeforeBuild(
            "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
      }
      return Container();
    });
  }

  Future addValueToTheList(String sessionId) async {
    do {
      try {
        var getBalance =
            await WsdlRequest().getAccountInfo(widget.getBankCode, sessionId);
        Map mapValue = Map<String, dynamic>.from(getBalance);
        if (mapValue["Account"] != null) {
          if (mapValue["Account"].runtimeType == List) {
            for (int i = 0; i < mapValue["Account"].length; i++) {
              mapValue["Account"][i]["Expanded"] = false;
              if (expandedValueList.length < mapValue["Account"].length) {
                expandedValueList.add(false);
              }
            }
          }else{
            expandedValueList.add(false);
          }
          return expandedValueList;
        }
      } catch (err) {
        log.e(err.toString());
      }
    } while (expandedValueList.isNotEmpty);
  }

  Future getAccountInfoMethod(String sessionId) async {
    var getBalance =
        await WsdlRequest().getAccountInfo(widget.getBankCode, sessionId);
    Map mapValue = Map<String, dynamic>.from(getBalance);
    int lengthOfList = 0;

    if (mapValue["Account"].runtimeType == List) {
      ///mapValue is a List

      ///todo
      for (int i = 0; i < mapValue["Account"].length; i++) {
        if (mapValue["Account"][i]["BankCode"] == widget.getBankCode) {
          lengthOfList = lengthOfList + 1;
        }
      }
    } else {
      ///mapValue is a single element
      lengthOfList = 1;

      ///todo
    }

    mapValue["LengthOfList"] = lengthOfList;
    return mapValue;
  }

  FutureBuilder addValueBeforeBuild(String sessionId){
    return FutureBuilder(
      future: addValueToTheList(sessionId),
      builder: (BuildContext context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.textFormUnderLineColor,
              ),
            ),
          );
        }
        return buildGetAccountInfoMethodBuilder(sessionId, snapshot.data);
      },
    );
  }
  FutureBuilder buildGetAccountInfoMethodBuilder(String sessionId, expandedValueLists) {
    return FutureBuilder(
      future: getAccountInfoMethod(sessionId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.textFormUnderLineColor,
              ),
            ),
          );
        }
        return buildCurrencyBloc(snapshot.data,expandedValueLists);
      },
    );
  }

  BlocBuilder buildCurrencyBloc(getData,expandedValueLists) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
      if (state is CurrencySmInitial) {
        return buildBody(getData, "TRY",expandedValueLists);
      } else if (state is CurrencySMEUR) {
        return buildBody(getData, "EUR",expandedValueLists);
      } else if (state is CurrencySMUSD) {
        return buildBody(getData, "USD",expandedValueLists);
      }
      return Container();
    });
  }

  ListView buildBody(getData, currency,expandedValueLists) {
    log.i(getData);
    return ListView.builder(
      itemCount: getData["LengthOfList"],
      itemBuilder: (context, index) {
        if (getData["LengthOfList"] == 1) {
          print(getData["LengthOfList"]);
          final getIban = getData["Account"]["AccountIban"];
          final getCurrency = getData["Account"]["CurrencyType"];
          final getAccountAvailableBalance =
          getData["Account"]["AvailableBalance"];
          final getAccountBalance =
          getData["Account"]["Balance"];
          final getAccountBlockedBalance =
          getData["Account"]["BlockedBalance"];
          final getCreditBalance = getData["Account"]["CreditBalance"];
          final getCreditBalanceUsed = getData["Account"]["CreditBalanceUsed"];
          final getCreditAvailableBalance = getData["Account"]["CreditAvailableBalance"];
          final branchName = getData["Account"]["BranchName"];
          if (getCurrency == currency) {
            return BankDetailsExpansionPanel(
              getCreditBalance: getCreditBalance,
                getCreditBalanceUsed: getCreditBalanceUsed,
                getCreditAvailableBalance: getCreditAvailableBalance,
                getAccountBalance: getAccountBalance,
                getAccountBlockedBalance: getAccountBlockedBalance,
                index: index,
                expandedValueList: expandedValueLists,
                bankCode: LocalHelper.getBankLogoString(widget.getBankCode),
                ibanNo: getIban,
                getAccountAvailableBalance: getAccountAvailableBalance,
                currency: LocalHelper.getCurrencyMethod(getCurrency),
                branchName: branchName);
          } else {
            return Container();
          }
        } else {
          final getIban = getData["Account"][index]["AccountIban"];
          final getAccountAvailableBalance =
              getData["Account"][index]["AvailableBalance"];
          final getAccountBalance =
          getData["Account"][index]["Balance"];
          final getAccountBlockedBalance =
          getData["Account"][index]["BlockedBalance"];
          final getCreditBalance = getData["Account"][index]["CreditBalance"];
          final getCreditBalanceUsed = getData["Account"][index]["CreditBalanceUsed"];
          final getCreditAvailableBalance = getData["Account"][index]["CreditAvailableBalance"];
          final branchName = getData["Account"][index]["BranchName"];
          final getCurrency = getData["Account"][index]["CurrencyType"];
          if (getCurrency == currency) {
            return BankDetailsExpansionPanel(
                getCreditBalance: getCreditBalance,
                getCreditBalanceUsed: getCreditBalanceUsed,
                getCreditAvailableBalance: getCreditAvailableBalance,
              getAccountBalance: getAccountBalance,
                getAccountBlockedBalance: getAccountBlockedBalance,
                index: index,
                expandedValueList: expandedValueList,
                bankCode: LocalHelper.getBankLogoString(widget.getBankCode),
                ibanNo: getIban,
                getAccountAvailableBalance: getAccountAvailableBalance,
                currency: LocalHelper.getCurrencyMethod(getCurrency),
                branchName: branchName);
          } else {
            return Container();
          }
        }
      },
    );
  }
}
