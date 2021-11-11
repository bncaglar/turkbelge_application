import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/AccountBalance/account_balance_screen.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/all_transactions/all_transactions_page.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class AccountBalanceTabController extends StatefulWidget {
  @override
  _AccountBalanceTabControllerState createState() =>
      _AccountBalanceTabControllerState();
}

class _AccountBalanceTabControllerState
    extends State<AccountBalanceTabController> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2.98.h,),
              buildTumHareketlerHeader(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TabBar(
                    labelColor: AppColors.icon_color,
                    isScrollable: true,
                    labelStyle: TextStyle(
                      fontSize: LocalHelper.getFontSize(14)
                    ),
                    indicatorColor: AppColors.SignInColorGradientStart,
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
                    AccountBalancePage(
                      getCurrency: "TÜMÜ",
                    ),

                    ///TÜMÜ
                    AccountBalancePage(
                      getCurrency: "TRY",
                    ),

                    ///TRY
                    AccountBalancePage(
                      getCurrency: "USD",
                    ),

                    ///USD
                    AccountBalancePage(
                      getCurrency: "EUR",
                    ),

                    ///EUR
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center buildTumHareketlerHeader() {
    return Center(
      child: Text(
        "HESAP BAKİYESİ",
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(15),
          color: AppColors.headerColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins'
        ),
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
