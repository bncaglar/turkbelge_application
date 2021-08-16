import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class BankAccountsHistoryPage extends StatefulWidget {
  const BankAccountsHistoryPage({Key? key}) : super(key: key);

  @override
  _BankAccountsHistoryPageState createState() =>
      _BankAccountsHistoryPageState();
}

class _BankAccountsHistoryPageState extends State<BankAccountsHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.accountInfoColor,
        body: buildBankAccountsHistoryBody(),
      ),
    );
  }

  SingleChildScrollView buildBankAccountsHistoryBody() {
    return SingleChildScrollView();
  }
}
