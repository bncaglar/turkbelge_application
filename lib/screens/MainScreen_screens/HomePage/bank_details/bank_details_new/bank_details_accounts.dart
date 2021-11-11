import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class BankDetailsAllAccounts extends StatefulWidget {

  final String getBankCode;

  BankDetailsAllAccounts(
      {required this.getBankCode});

  @override
  _BankDetailsAllAccountsState createState() => _BankDetailsAllAccountsState();
}

class _BankDetailsAllAccountsState extends State<BankDetailsAllAccounts> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
final log = Logger();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13.70.h*5.5,
      padding: EdgeInsets.only(
        top: 1.90.h,
        right: 2.65.w,
        left: 2.65.w,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.13),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: buildGroupCompany(),
    );
  }

  BlocBuilder buildGroupCompany(){
    return BlocBuilder<DropdownCubit, DropdownState>(
        builder: (context, state){
          if(state is DropdownInitial){
            return buildGetAccountInfoMethodBuilder("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E");
          }else if(state is DropdownSecondCompany){
            return buildGetAccountInfoMethodBuilder("B]Ygv=uZx?jDUV>e1jB*dKJ99%V46C");
          }
          return Container();
        }
    );
  }

  Future getAccountInfoMethod(String sessionId)async{
    var getBalance = await WsdlRequest().getAccountInfo(widget.getBankCode,sessionId);
    Map mapValue = Map<String, dynamic>.from(getBalance);
    int numberOfAccount = mapValue["Account"].length;
    int lengthOfList = 0;

    for(int i = 0; i< numberOfAccount; i++){
      if(getBalance["Account"].length == 5) {
        print("aşama 1 ");
        try{
          if(getBalance["Account"]["AccountIban"].length == 26){
            print("aşama 2 ");
            if(mapValue["Account"]["BankCode"] == widget.getBankCode){///KB00 is an example, we put the widget.bankCode
              print("aşama 3");
              lengthOfList = 1;
            }
          }
        }catch(e){
          if(mapValue["Account"][i]["BankCode"] == widget.getBankCode){ ///KB00 is an example, we put the widget.bankCode
            lengthOfList = lengthOfList + 1;
          }
        }
      }
      else{
        if(mapValue["Account"][i]["BankCode"] == widget.getBankCode){ ///KB00 is an example, we put the widget.bankCode
          lengthOfList = lengthOfList + 1;
        }
      }
    }
    mapValue["LengthOfList"] = lengthOfList;
    log.i(mapValue);
   return mapValue;
  }

  FutureBuilder buildGetAccountInfoMethodBuilder(String sessionId){
    return FutureBuilder(
      future: getAccountInfoMethod(sessionId),
      builder: (BuildContext context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.textFormUnderLineColor,),),);
        }
        return buildCurrencyBloc(snapshot.data);
      },
    );
  }
  BlocBuilder buildCurrencyBloc(getData) {
    return BlocBuilder<CurrencySmCubit, CurrencySmState>(
        builder: (context, state) {
          if (state is CurrencySmInitial) {
            return buildBody(getData, "TRY");
          } else if (state is CurrencySMEUR) {
            return buildBody(getData, "EUR");
          } else if (state is CurrencySMUSD) {
            return buildBody(getData, "USD");
          }
          return Container();
        }
    );
  }

  ListView buildBody(getData, currency){
    return ListView.builder(
      itemCount: getData["LengthOfList"],
      itemBuilder: (context, index){
        if(getData["LengthOfList"] == 1){
          print(getData["LengthOfList"]);
          final getIban = getData["Account"]["AccountIban"];
          final getCurrency = getData["Account"]["CurrencyType"];
          final getAccountBalance = getData["Account"]["AvailableBalance"];
          final branchName = getData["Account"]["BranchName"];
          if(getCurrency == currency){
            return buildEachContainer(LocalHelper.getBankLogoString(widget.getBankCode), getIban,
                getAccountBalance, LocalHelper.getCurrencyMethod(getCurrency), branchName);
          }else{
            return Container();
          }
        }else{
          final getIban = getData["Account"][index]["AccountIban"];
          final getAccountBalance = getData["Account"][index]["AvailableBalance"];
          final branchName = getData["Account"][index]["BranchName"];
          final getCurrency = getData["Account"][index]["CurrencyType"];
          if(getCurrency == currency){
            return buildEachContainer(LocalHelper.getBankLogoString(widget.getBankCode), getIban,
                getAccountBalance, LocalHelper.getCurrencyMethod(getCurrency), branchName);
          }else{
            return Container();
          }
        }
      },
    );
  }


  Container buildEachContainer(String bankIconPath, String ibanNo,
      String balance, String currency, branchName) {
    return Container(
      height: 13.05.h,
      padding: EdgeInsets.only(
        bottom: 1.h,
        right: 5.07.w,
        left: 5.07.w,
      ),
      child: buildEachContainerColumn(
          bankIconPath, ibanNo, balance, currency, branchName),
      decoration: BoxDecoration(color: Colors.white),
    );
  }


  Column buildEachContainerColumn(String bankIconPath, String ibanNo,
      String balance, String currency, branchName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4.55.h,
          width: 24.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              bankIconPath,
              scale: 2.1,
            ),
          ),
        ),
        buildAccountInfoRow(ibanNo, balance, currency),
        SizedBox(
          height: 5,
        ),
        buildBranchNameText(branchName),
        SizedBox(
          height: 1.50.h,
        ),
        buildStraightLine(),
      ],
    );
  }

  Row buildAccountInfoRow(String ibanNo, String balance, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ibanNo,
          style: TextStyle(
              color: AppColors.headerColor,
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400),
        ),
        Text(
          "${oCcy.format(double.parse(balance))} $currency",
          style: TextStyle(
              color: AppColors.accountBalanceColor,
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Text buildBranchNameText(branchName) {
    return Text(
      branchName,
      style: TextStyle(
          color: AppColors.infoContentDialogColor,
          fontSize: LocalHelper.getFontSize(10),
          fontFamily: 'Poppins'),
    );
  }

  Center buildStraightLine() {
    return Center(
      child: Container(
        height: 0.5,
        width: 84.w,
        color: AppColors.textFormUnderLineColor,
      ),
    );
  }
}
