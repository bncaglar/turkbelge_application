import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class HomePageHalfDown extends StatefulWidget {
  @override
  _HomePageHalfDownState createState() => _HomePageHalfDownState();
}

class _HomePageHalfDownState extends State<HomePageHalfDown> {
  var listOfBanks = [
    "assets/garanti-bankasi-logo.png",
    "assets/2560px-Akbank_logo.svg.png",
    "assets/1280px-DenizBank_logo.svg.png",
    "assets/1280px-Türkiye_İş_Bankası_logo.svg.png"
  ];

  var listofAccount = [
    2,
    1,
    4,
    9,
  ];

  var listOfBalance = [
    "3,526,00 TL",
    "5,023,00 TL",
    "9,332,00 TL",
    "592,00 TL",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44.h,
        child: buildListView(),);
  }

  ListView buildListView(){
    return ListView.builder(
      padding: EdgeInsets.only(top: 1.08.h),
      itemCount: 4,
        itemBuilder: (context, index){
        final logoPath = listOfBanks[index];
        final listOfAccountList = listofAccount[index];
        final balanceList = listOfBalance[index];
        return buildEachBankRow(logoPath, listOfAccountList, balanceList);
        },
    );
  }

  Padding buildEachBankRow(String bankLogoSvg, int listofAccountList, String balanceList){
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w),
      child: Container(
        height: 7.47.h,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                buildBankLogo(bankLogoSvg),
                buildNumberOfAccount(listofAccountList),
                Spacer(),
                buildAccountBalance(balanceList),
              ],
            ),
            Container(
              height: 1,
              width: 84.54.w,
              color: AppColors.textFormUnderLineColor,
            )
          ],
        ),
      ),
    );
  }

  Padding buildBankLogo(String bankLogoSvg){
    return Padding(
      padding: EdgeInsets.only(right: 22.22.w),
      child: Column(
        children: [
          Container(
            width: 23.42.w,
            height: 7.26.h,
            child: Image.asset(bankLogoSvg),
          ),
        ],
      ),
    );
  }

  Text buildNumberOfAccount(int numberOfAcc){
    return Text(
      "$numberOfAcc Hesap",
      style: TextStyle(
        color: AppColors.infoContentDialogColor,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(10),
      ),
    );
  }

  Text buildAccountBalance(String balanceList){
    return Text(
        balanceList,
      style: TextStyle(
        color: AppColors.headerColor,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(13),
      ),
    );
  }
}
