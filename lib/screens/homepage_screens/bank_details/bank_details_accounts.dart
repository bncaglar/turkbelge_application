import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class BankAccountsSummary extends StatefulWidget {
  const BankAccountsSummary({Key? key}) : super(key: key);

  @override
  _BankAccountsSummaryState createState() => _BankAccountsSummaryState();
}

class _BankAccountsSummaryState extends State<BankAccountsSummary> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
      ),
    );
  }
}
