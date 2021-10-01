import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/services/Banks/dummyData.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:xml2json/xml2json.dart';

class NumberOfBankAndAccount extends StatefulWidget {
  String? customerNumber;
  NumberOfBankAndAccount({required customerNumber});
  @override
  _NumberOfBankAndAccountState createState() => _NumberOfBankAndAccountState();
}

class _NumberOfBankAndAccountState extends State<NumberOfBankAndAccount> {
  @override
  Widget build(BuildContext context) {
    return buildNumberOfAccountColumn();
  }

  Container buildNumberOfAccountColumn() {
    return Container(
      padding: EdgeInsets.only(left: 5.w, top: 1.5.h, bottom: 1.5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildNumberOfBank(),
          buildNumberOfAccount(),
        ],
      ),
    );
  }

  FutureBuilder buildNumberOfBank() {
    return FutureBuilder<int?>(
      future: getNumberOfBank("313165"),
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        int? numberOfBank = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('...');
          default:
            if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              return Text(
                numberOfBank.toString() + " Banka",
                style: TextStyle(
                  fontSize: LocalHelper.getFontSize(12),
                  color: AppColors.accountInfoColor,
                  fontWeight: FontWeight.w300,
                ),
              );
            }
        }
      },
    );
  }

  FutureBuilder buildNumberOfAccount() {
    return FutureBuilder<int?>(
      future: getNumberOfAccount(),
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        int? toplamHesap = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('...');
          default:
            if (snapshot.hasError)
              return Text('Hata: ${snapshot.error}');
            else
              return Text(
                toplamHesap.toString() + " Hesap",
                style: TextStyle(
                  fontSize: LocalHelper.getFontSize(12),
                  color: AppColors.accountInfoColor,
                  fontWeight: FontWeight.w300,
                ),
              );
        }
      },
    );
  }

  Future<int?> getNumberOfAccount() async {


    return 2;
  }

  Future<int?> getNumberOfBank(String _customerNumber) async {
    var numberOfBankList =
        await FireStoreService().getNumberOfBank(_customerNumber);
    print(numberOfBankList);
    return numberOfBankList.length;
  }
}
