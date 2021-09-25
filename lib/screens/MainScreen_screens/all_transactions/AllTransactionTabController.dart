import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

import 'all_transactions_page.dart';

class AllTransactionTabController extends StatefulWidget {
  @override
  _AllTransactionTabControllerState createState() =>
      _AllTransactionTabControllerState();
}

class _AllTransactionTabControllerState
    extends State<AllTransactionTabController> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.newColor4Background,
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTumHareketlerHeader(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabBar(

                    labelColor: AppColors.primaryWightColor,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: AppColors.primaryWightColor,
                   tabs: [
                      Tab(text: "Tümü"),
                      Tab(text: "TRY"),
                      Tab(text: "USD"),
                      Tab(text: "EUR"),
                    ],
                  ),
                ],
              ),
              Container(
                height: 74.h,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AllTransactionsPage(getCurrency: "TÜMÜ",), ///TÜMÜ
                    AllTransactionsPage(getCurrency: "TRY",), ///TRY
                    AllTransactionsPage(getCurrency: "USD",), ///USD
                    AllTransactionsPage(getCurrency: "EUR",), ///EUR
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTumHareketlerHeader() {
    return Container(
      width: double.infinity,
      height: 5.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Tüm Hareketler",
              style: TextStyle(
                fontSize: LocalHelper.getFontSize(16),
                color: AppColors.homepageTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
// Container searchNotificationsField() {
//   return Container(
//     padding: EdgeInsets.only(right: 3.w),
//     width: widget.searchFieldWidth ?? 72.w,
//     height: widget.searchFieldHeight ?? 5.62.h,
//     child: SearchChallengesField(
//       onTapSuffixIcon: onClickSuffixIcon,
//       onChanged: widget.onChanged,
//       onEditingComplete: widget.onEditingComplete,
//       addSearchFieldTitle: widget.addSearchFieldTitle,
//       controller: searchController,
//       serverSearchErrorText: null, //todo send server error here
//     ),
//   );
// }
}
