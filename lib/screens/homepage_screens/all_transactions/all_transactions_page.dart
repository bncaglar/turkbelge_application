import 'package:flutter/material.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';

import 'all_transactions_components/all_transactions_appbar.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  final log = getLogger();

  onClickMoreVert() {
    log.i("onClickMoreVert started");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: AllTransactionsAppBar(
            onClickMoreVert: onClickMoreVert,
            searchFieldWidth: 57.w,
          ),
        ),
      ),
    );
  }
}
