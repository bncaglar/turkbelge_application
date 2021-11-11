import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ExpansionPanelDemo extends StatefulWidget {
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 35.76.h,
        width: double.infinity,
        child: buildGroupCompany(),
      ),
    );
  }

  BlocBuilder buildGroupCompany(){
    return BlocBuilder<DropdownCubit, DropdownState>(
        builder: (context, state){
          if(state is DropdownInitial){
            return buildCurrencyBloc("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
          }else if(state is DropdownSecondCompany){
            return buildCurrencyBloc("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
          }
          return Container();
        }
    );
  }

  BlocBuilder buildCurrencyBloc(String sessionId) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
          if (state is CurrencySmInitial) {
            print("State: $CurrencySmInitial");
            return buildListViewBuilder("TRY",sessionId);
          } else if (state is CurrencySMEUR) {
            return buildListViewBuilder("EUR",sessionId);
          } else if (state is CurrencySMUSD) {
            return buildListViewBuilder("USD",sessionId);
          }
          return Container();
        });
  }

  FutureBuilder buildListViewBuilder(String currency, String sessionId){
    return FutureBuilder(
      future:getBankInfoMethod(sessionId),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.textFormUnderLineColor,
                ),
              ),
            );
          }
          case ConnectionState.active:{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.textFormUnderLineColor,
                ),
              ),
            );
          }
          default:
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return buildListView(snapshot.data,currency);
              }else if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textFormUnderLineColor,
                    ),
                  ),
                );
              }
            }
            return buildListView(snapshot.data,currency);
        }
      },
    );
  }

  ListView buildListView(getData, String currency){
    return ListView.builder(
      padding: EdgeInsets.only(top: 1.08.h),
      itemCount: itemData.length,
      itemBuilder: (BuildContext context, int index) {
        final bankCode = getData["Account"][index]["BankCode"];
        final balanceList = getData["Account"][index]["AvailableBalance"];
        var expandedValue = getData["Account"][index]["Expanded"];
        return buildExpansionPanel(index,bankCode,balanceList,currency,expandedValue);
      },
    );
  }

  Padding buildExpansionPanel(index,bankCode, balanceList,currency,expandedValue){
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w),
      child: ExpansionPanelList(
        animationDuration: Duration(milliseconds: 1000),
        dividerColor: Colors.red,
        elevation: 1,
        children: [
          ExpansionPanel(
            body: Container(
              width: 92.02.w,
              decoration: BoxDecoration(
                color: AppColors.dismissRedColor,
                border: Border.all(
                    color: AppColors.columnChartHalfDownContainerBorderColor),
              ),
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return buildHeaderContainer(bankCode, 5, balanceList,currency);
            },
            isExpanded: expandedValue,
          )
        ],
        expansionCallback: (int item, bool status) {
          setState(() {
            expandedValue = !expandedValue;
          });
        },
      ),
    );
  }
  Container buildHeaderContainer(String bankCode, numberOfAcc, balanceList, String currency){
    return Container(
      height: 9.69.h,
      width: 92.02.w,
      decoration: BoxDecoration(
        color: AppColors.primaryWightColor,
        border: Border.all(
            color: AppColors.columnChartHalfDownContainerBorderColor),
      ),
      child: Row(
        children: [
          buildBankLogo(bankCode, numberOfAcc),
          Spacer(),
          buildRightSide(balanceList,currency),

        ],
      ),
    );
  }

  Row buildRightSide(balanceList,String currency ){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2.17.h, right: 2.22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildBalance(balanceList, currency),
              Row(
                children: [
                  Text(
                    "15.450,00 TL",
                    style: TextStyle(
                      color: AppColors.infoContentDialogColor,
                      fontFamily: 'Poppins',
                      fontSize: LocalHelper.getFontSize(10),
                    ),
                  ),
                  SizedBox(
                    width: 1.44.w,
                  ),
                  buildPercentageRow("%15"),
                ],
              )
            ],
          ),
        ),

      ],
    );
  }

  Row buildPercentageRow(String percentageChanges,) {
    bool trueFalsex =false;
    return Row(
      children: [
        SvgPicture.asset(
          trueFalsex ? "svg/Polygon.svg" : "svg/UnPolygon.svg",
          color: trueFalsex
              ? AppColors.truePercentageColor
              : AppColors.SignInColorGradientStart,
        ),
        SizedBox(
          width: 1.44.w,
        ),
        Text(
          percentageChanges,
          style: TextStyle(
            color: trueFalsex
                ? AppColors.truePercentageColor
                : AppColors.SignInColorGradientStart,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(11),
          ),
        ),
      ],
    );
  }

  Row buildBalance(String balanceList, currency) {
    return Row(
      children: [
        Text(
          oCcy.format(double.parse(balanceList)),
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
          ),
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          LocalHelper.getCurrencyMethod(currency),
          style: TextStyle(
            color: AppColors.headerColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
          ),
        ),
      ],
    );
  }

  Padding buildBankLogo(String bankCode, numberOfAcc) {
    return Padding(
      padding: EdgeInsets.only(left: 2.22.w),
      child: Column(
        children: [
          Container(
            width: 23.42.w,
            height: 6.26.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                LocalHelper.getBankLogoString(bankCode),
                scale: 2.1,
              ),
            ),
          ),
          Text(
            "$numberOfAcc Hesap",
            style: TextStyle(
              color: AppColors.infoContentDialogColor,
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(10),
            ),
          ),
        ],
      ),
    );
  }

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
        headerItem: 'Android',
        discription:
        "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
        colorsItem: Colors.green,
        img: 'assets/images/android_img.png'
    ),
    ItemModel(
        headerItem: 'Android',
        discription:
        "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
        colorsItem: Colors.green,
        img: 'assets/images/android_img.png'
    ),
  ];

  Future getBankInfoMethod(String sessionId) async{
      while(true){
        try {
          var getBalance = await WsdlRequest().getAccountInfo("ALL",sessionId);
          Map mapValue = Map<String, dynamic>.from(getBalance);
          if(mapValue["Account"] != null){
            if(mapValue["Account"].runtimeType == List){
              for(int i = 0; i<mapValue["Account"].length; i++){
                mapValue["Account"][i]["Expanded"] = false;
              }
              mapValue = Map<String, dynamic>.from(getBalance);
              print(mapValue);
              return mapValue;
            }else{
              mapValue["Account"]["Expanded"] = false;
              return mapValue;
            }
          }
        } catch (e) {
          print(e.toString());
        }
      }
  }

}

class ItemModel {
  bool expanded;
  String headerItem;
  String discription;
  Color colorsItem;
  String img;
  ItemModel(
      {this.expanded: false,
      required this.headerItem,
      required this.discription,
      required this.colorsItem,
      required this.img});
}
