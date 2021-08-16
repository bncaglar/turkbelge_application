import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';

import 'bank_details_tab_controller.dart';

class BankDetailsPage extends StatefulWidget {
  static const routeName = '/BankDetailsPage';
  final String? bankName;
  final String? bankAccountKey;
  final String? bankIcon;
  final BoxFit? fitt;
  BankDetailsPage(
      {required this.bankAccountKey,
      required this.bankIcon,
      required this.bankName,
      required this.fitt});

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: CustomAppBar(
            searchFieldWidth: 57.w,
            imagePath: widget.bankIcon!,
            fitt: widget.fitt!,
          ),
        ),
        backgroundColor: AppColors.primaryWightColor,
        body: BankDetailsOfTabController(
          bankIcon: widget.bankIcon!,
          bankAccountKey: widget.bankAccountKey!,
          bankName: widget.bankName!,
          fitt: widget.fitt!,
        ),
      ),
    );
  }

  Column buildBankDetailsPageBody() {
    return Column(
      children: [],
    );
  }
}

class BankDetailsPageArguments {
  String? bankName;
  String? bankIcon;
  String? bankAccountKey;
  BoxFit? fitt;
  BankDetailsPageArguments(
      {required this.bankIcon,
      required this.bankName,
      required this.bankAccountKey,
      required this.fitt});
}
