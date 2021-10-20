import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/services/Banks/ZiraatBank/getZiraatXmlResponse.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';

import 'number_of_bank_and_account.dart';

class TotalBalanceContainerOnHomePage extends StatefulWidget {
  final String? customerNumber;
  final bool isUserAdmin;
  final String? subUserEmail;
  final String? getCurrency;

  TotalBalanceContainerOnHomePage(
      {required this.subUserEmail,
      required this.getCurrency,
      required this.isUserAdmin,
      required this.customerNumber});

  @override
  _TotalBalanceContainerOnHomePageState createState() =>
      _TotalBalanceContainerOnHomePageState();
}

class _TotalBalanceContainerOnHomePageState
    extends State<TotalBalanceContainerOnHomePage> {
  @override
  Widget build(BuildContext context) {
    return buildBalanceContainer();
  }

  Center buildBalanceContainer() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Container(
          height: 10.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: AppColors.homepageTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NumberOfBankAndAccount(
                subUserEmail: widget.subUserEmail,
                customerNumber: widget.customerNumber,
                isUserAdmin: widget.isUserAdmin,
              ),
              buildAccountTotalBalance(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildAccountTotalBalance() {
    return Container(
      width: 50.w,
      child: Center(
        child: FutureBuilder<double?>(
          future: widget.isUserAdmin
              ? getAvailableBalanceForAdmin(widget.customerNumber!)
              : getAvailableBalanceForSubUser(),
          builder: (BuildContext context, AsyncSnapshot<double?> snapshot) {
            double? toplamBakiye = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('...');
              default:
                return Text(
                  "${toplamBakiye.toString()} ${widget.getCurrency}",
                  style: TextStyle(
                    fontSize: LocalHelper.getFontSize(15),
                    color: Colors.green,
                    fontWeight: FontWeight.w400,
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<double?> getAvailableBalanceForAdmin(String _customerNumber) async {
    try {
      var numberOfBankList =
          await FireStoreService().getNumberOfBankForAdminList(_customerNumber);
      var nameOfBanksAndCredentials;
      String? availableBalance = "";
      double balance = 0;
      double totalBalance = 0;
      for (int i = 0; i < numberOfBankList.length; i++) {
        for (int x = 0; x < numberOfBankList[i]["NumberOfAccount"]; x++) {
          nameOfBanksAndCredentials = await FireStoreService()
              .getNumberOfBankForAdminListWithAccount(
                  _customerNumber, numberOfBankList[i]["bankName"]);
          availableBalance = await GetZiraatXmlResponse().getAvailableBalance(
              nameOfBanksAndCredentials[x]["bankCode"],
              nameOfBanksAndCredentials[x]["sessionID"]);
          print(nameOfBanksAndCredentials[x]["sessionID"]);
          balance = double.parse(availableBalance!);
          totalBalance = totalBalance + balance;
        }
      }
      return totalBalance;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<double?> getAvailableBalanceForSubUser() async {
    try {
      String? availableBalance = await GetZiraatXmlResponse()
          .getAvailableBalance("ZB00", "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
      double balance = double.parse(availableBalance!);
      return balance;
    } catch (e) {
      return 0;
    }
  }
}
