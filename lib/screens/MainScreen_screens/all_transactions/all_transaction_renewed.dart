import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class AllTransactionRenewed extends StatefulWidget {
  @override
  _AllTransactionRenewedState createState() => _AllTransactionRenewedState();
}

class _AllTransactionRenewedState extends State<AllTransactionRenewed> {
  var listOfExpenses = [
    "Gider",
    "Gelir",
    "Gider",
    "Gider",
  ];

  var remainingBalance = [
    "225.00 TL",
    "509.00 TL",
    "225.00 TL",
    "225.00 TL",
  ];
  var revenueAmount = [
    "- 88.00 TL",
    "+ 250.00 TL",
    "- 88.00 TL",
    "- 88.00 TL",
  ];
  var listOfBanks = [
    "assets/2560px-Akbank_logo.svg.png",
    "assets/2560px-Akbank_logo.svg.png",
    "assets/1280px-DenizBank_logo.svg.png",
    "assets/1280px-Türkiye_İş_Bankası_logo.svg.png"
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildUp(),
        buildListView(),
      ],
    );
  }

  Flexible buildUp(){
    return Flexible(
      flex: 1,
        child: Column(
          children: [
            buildHeaderText(),
            buildFilterRow(),
            buildStraightHeaderLine(),
          ],
        ),
    );
  }

  Padding buildHeaderText() {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.71.h,
        bottom: 3.39.h,
      ),
      child: Center(
        child: Text(
          "Hareketler",
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(17),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Padding buildFilterRow() {
    return Padding(
      padding: EdgeInsets.only(
        right: 7.72.w,
        left: 7.72.w,
        bottom: 1.42.h,
      ),
      child: Row(
        children: <Widget>[
          buildAscendingFilter(),
          buildFilter(),
          buildResetText(),
        ],
      ),
    );
  }

  Padding buildAscendingFilter() {
    return Padding(
      padding: EdgeInsets.only(
        right: 2.17.w,
      ),
      child: Container(
        width: 40.33.w,
        height: 4.89.h,
        decoration: BoxDecoration(
          color: AppColors.primaryWightColor,
          border: Border.all(color: AppColors.filterBorderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.boxShadowColor.withOpacity(0.10),
              spreadRadius: 3,
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 4.83.w,
            right: 4.83.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Yeniden",
                style: TextStyle(
                  color: AppColors.filterAgainTextColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SvgPicture.asset("svg/arrow_up_down.svg"),
              Text(
                "Eskiye",
                style: TextStyle(
                  color: AppColors.filterAgainTextColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildFilter() {
    return Padding(
      padding: EdgeInsets.only(right: 2.89.w),
      child: Container(
        height: 4.89.h,
        width: 25.12.w,
        decoration: BoxDecoration(
          color: AppColors.primaryWightColor,
          border: Border.all(color: AppColors.filterBorderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.boxShadowColor.withOpacity(0.10),
              spreadRadius: 3,
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 1.93.w,
            right: 1.93.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SvgPicture.asset("svg/arrow_up_down.svg"),
              Text(
                "Filtre",
                style: TextStyle(
                  color: AppColors.filterAgainTextColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
               Container(
                 height: 2.98.h,
                 width: 5.31.w,
                 decoration: BoxDecoration(
                   color: AppColors.navigationBorderColor,
                   borderRadius: BorderRadius.all(
                     Radius.circular(4),
                   ),
                 ),
                 child: Center(
                   child: Text(
                     "3",
                     style: TextStyle(
                       color: AppColors.filterAgainTextColor,
                       fontFamily: 'Poppins',
                       fontSize: LocalHelper.getFontSize(12),
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildResetText() {
    return Container(
      width: 14.w,
      child: Center(
        child: Text(
          "Tümünü Sıfırla",
          style: TextStyle(
            color: AppColors.SignInColorGradientStart,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container buildStraightHeaderLine(){
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.SignInColorGradientStart,
    );
  }

  Flexible buildListView(){
    return Flexible(
      flex: 4,
      child: Container(
        color: AppColors.allTransactionBackgroundColor,
        child: buildListViewBuilder(),
      ),
    );
  }

  ListView buildListViewBuilder(){
    return ListView.builder(
      itemCount: 4,
        itemBuilder: (context, index){
          final bankIconPath = listOfBanks[index];
          final amount = revenueAmount[index];
          final remaining = remainingBalance[index];
          final expenses = listOfExpenses[index];
          return buildEachBox(bankIconPath, expenses, amount, remaining);
        }
    );
  }

  Padding buildEachBox(String bankIconPath, String expenses, String amount, String remainingBalance){
    return Padding(
      padding: EdgeInsets.only(bottom: 1.22.h),
      child: Center(
        child: Container(
          height: 17.52.h,
          width: 94.68599033816425.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.allTransactionBoxShadowColor.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 5.07.w,
                  top: 2.85.h,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset("svg/receipt.svg"),
                ),
              ),
              buildBoxColumn(bankIconPath, expenses, amount, remainingBalance),
            ],
          ),
        ),
      ),
    );
  }
  Padding buildBoxColumn(String bankIconPath, String expenses, String amount, String remainingBalance){
    return Padding(
      padding: EdgeInsets.only(
        left: 5.07.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start  ,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 40.50.w
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                    bankIconPath,
                    scale: 2.1,
                  ),
                ),
                Text(
                  "23/08/2021 - 11:15",
                  style: TextStyle(
                    color: AppColors.icon_color,
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Türkiye Hayat Ve Emeklilik Anonim Şirketi",
            style: TextStyle(
              color: AppColors.headerColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(13),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "3486001 Dosya referanslı otomatik katılım ödemesi",
            style: TextStyle(
              color: AppColors.infoContentDialogColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(10),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 1.35.h,),
          Center(
            child: Container(
              width: 89.85.w,
              height: 1,
              color: AppColors.allTransactionBoxStraightLineColor,
            ),
          ),
          SizedBox(height: 0.95.h,),
          buildRevenue(expenses, amount, remainingBalance)
        ],
      ),
    );
  }

  Row buildRevenue(String expenses, String amount, String remainingBalance){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRevenueTextColumn(expenses, amount),
        Container(
          height: 5.40.h,
          width: 1,
          color: AppColors.allTransactionBoxStraightLineColor,
        ),
        buildRemainingAmountColumn(remainingBalance),
      ],
    );
  }

  Column buildRevenueTextColumn(String expenses, String amount){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Text(
         expenses,
        style: TextStyle(
        color: AppColors.infoContentDialogColor,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(12),
        fontWeight: FontWeight.w400,
          ),
       ),
      SizedBox(height: 1,),
      Text(
        amount,
        style: TextStyle(
          color: expenses == "Gelir" ? AppColors.allTransactionGelirColor : AppColors.SignInColorGradientStart,
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(14),
          fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Column buildRemainingAmountColumn(String remainingBalance){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Kalan Bakiye",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 1,),
        Text(
          remainingBalance,
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
