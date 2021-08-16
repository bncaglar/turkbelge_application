import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: CustomAppBar(
            buildAppBarRowLeftSide: false,
            addBackBtn: false,
            addBankImage: false,
            searchFieldWidth: 57.w,
          ),
        ),
      ),
    );
  }
}
