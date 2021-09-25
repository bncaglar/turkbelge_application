import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/services/Banks/XmlParse.dart';
import 'package:turkbelge_application/services/Banks/dummyData.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

import 'number_of_bank_and_account.dart';

class TotalBalanceContainerOnHomePage extends StatefulWidget {
  String? customerNumber;
  TotalBalanceContainerOnHomePage({required this.customerNumber});
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
              NumberOfBankAndAccount(customerNumber: widget.customerNumber),
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
          future: getAvailableBalance(),
          builder: (BuildContext context, AsyncSnapshot<double?> snapshot) {
            double? toplamBakiye = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Yükleniyor..');
              default:
                if (snapshot.hasError)
                  return Text('Hata: ${snapshot.error}');
                else
                  return Text(
                    toplamBakiye.toString() + " TRY",
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

  Future<double?> getAvailableBalance() async {
    final log = Logger();
    try {
      double toplamBakiye = 0;
      final Xml2Json xml2Json = Xml2Json();
      xml2Json.parse(DummyDataResponse.response);
      var jsonString = xml2Json.toParker();
      var data = jsonDecode(jsonString);
      log.i(data["BankTransactionResponse"]["ArrayOfAccounts"]["Account"].length);
      int numberOfAccount =
          data["BankTransactionResponse"]["ArrayOfAccounts"]["Account"].length;
      print(numberOfAccount.toString()+" ss");
      if(numberOfAccount >=1){
        for (int i = 0; i < numberOfAccount; i++) {
          toplamBakiye = toplamBakiye +
              double.parse(data["BankTransactionResponse"]["ArrayOfAccounts"]["Account"][i]["AvailableBalance"]);
        }
      }else{
        toplamBakiye = data["BankTransactionResponse"]["ArrayOfAccounts"]["Account"][0]["AvailableBalance"];
      }
      log.i(toplamBakiye);
      return toplamBakiye;
    } catch (e) {
      return 0;
    }
  }

}
