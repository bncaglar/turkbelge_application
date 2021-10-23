import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class HomePageHalfDownPie extends StatefulWidget {
  @override
  _HomePageHalfDownPieState createState() => _HomePageHalfDownPieState();
}

class _HomePageHalfDownPieState extends State<HomePageHalfDownPie> {

  var listOfColors = [
    AppColors.chartColorBlue,
    AppColors.chartColorYellow,
    AppColors.chartColorGreen,
    AppColors.chartColorReddish
  ];

  var listOfBanks = [
    "Garanti",
    "Akbank",
    "Denizbank",
    "Türkiye İş Bankası",
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

  var percentage = [
    "23.99%",
    "23.91%",
    "25.23%",
    "26.87%"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      child: buildListView(),);
  }
  ListView buildListView(){
    return ListView.builder(
      padding: EdgeInsets.only(top: 2.71.h),
      itemCount: 4,
      itemBuilder: (context, index){
        final percentageList = percentage[index];
        final bankName = listOfBanks[index];
        final listOfAccountList = listofAccount[index];
        final balanceList = listOfBalance[index];
        final colorList = listOfColors[index];
        return buildEachBankRow(bankName, listOfAccountList, balanceList, colorList, percentageList);
      },
    );
  }
  Padding buildEachBankRow(String bankName, int listofAccountList, String balanceList, Color color, String percentageList){
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w),
      child: Container(
        height: 7.20.h,
        color: AppColors.primaryWightColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBankAccountRow(color,bankName, listofAccountList),
                buildPercentage(percentageList),
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

  Row buildBankAccountRow(Color color,String bankName, int listofAccountList,){
    return Row(
      children: <Widget>[
        buildBankColor(color),
        buildBankInfoColumn(bankName, listofAccountList)
      ],
    );
  }

  Column buildBankInfoColumn(String bankName, int numberOfAcc){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bankName,
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(13),
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 1.h, width: 42.43.w,),
        Text(
          "$numberOfAcc Hesap",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(10),
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Padding buildBankColor(Color color){
    return Padding(
      padding: EdgeInsets.only(
        right: 2.17.w,
        bottom: 1.15.h,
        top: 1.15.h
      ),
      child: Container(
        height: 4.75.h,
        width: 1.44.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  Text buildPercentage(String percentage){
    return Text(
      percentage,
      style: TextStyle(
        color: AppColors.icon_color,
        fontFamily: 'Poppins',
        fontSize: LocalHelper.getFontSize(11),
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
