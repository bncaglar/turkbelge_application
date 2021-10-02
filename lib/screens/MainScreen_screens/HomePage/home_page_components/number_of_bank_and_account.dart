
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class NumberOfBankAndAccount extends StatefulWidget {
  final String? customerNumber;
  final bool isUserAdmin;
  final String? subUserEmail;

  NumberOfBankAndAccount(
      {required this.subUserEmail,
      required this.isUserAdmin,
      required this.customerNumber});

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
      future: widget.isUserAdmin
          ? getNumberOfBankForAdmin(widget.customerNumber!)
          : getNumberOfBankForSubUser(
              widget.customerNumber!, widget.subUserEmail!),
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        int? numberOfBank = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('...');
          default:
              return Text(
                numberOfBank.toString() + " Banka",
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

  FutureBuilder buildNumberOfAccount() {
    return FutureBuilder<int?>(
      future: widget.isUserAdmin
          ? getNumberOfAccountForAdmin(widget.customerNumber!)
          : getNumberOfAccountForSubUser(
              widget.customerNumber!, widget.subUserEmail!),
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

  Future<int?> getNumberOfAccountForAdmin(String _customerNumber) async {
    var numberOfAccountList =
        await FireStoreService().getNumberOfAccountForAdmin(_customerNumber);
    return numberOfAccountList;
  }

  Future<int?> getNumberOfAccountForSubUser(
      String _customerNumber, String _email) async {
    var numberOfAccountList = await FireStoreService()
        .getNumberOfAccountForSubUser(_customerNumber, _email);
    return numberOfAccountList;
  }

  Future<int?> getNumberOfBankForAdmin(String _customerNumber) async {
    var numberOfBankList =
        await FireStoreService().getNumberOfBankForAdmin(_customerNumber);
    return numberOfBankList;
  }

  Future<int?> getNumberOfBankForSubUser(
      String _customerNumber, String _email) async {
    var numberOfBankList = await FireStoreService()
        .getNumberOfBankForSubUser(_customerNumber, _email);
    return numberOfBankList;
  }
}
