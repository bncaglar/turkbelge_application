import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/logic/account_sm/account_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/bank_details/bank_details_new/bank_details_page.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBalancePage extends StatefulWidget {
  String getCurrency;

  AccountBalancePage({required this.getCurrency});

  @override
  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {

  final oCcy = new NumberFormat("#,##0.00", "tr_TR");
  final log = Logger();

  onClickBank(String bankCode) {
    log.i("onClickBank started");
    context.read<AccountAndTransactionCubit>().changState(AccountAndTransactionEmit(bankCode: bankCode));
  }


  @override
  Widget build(BuildContext context) {
    return buildCurrencyBloc();
  }
  BlocBuilder buildCurrencyBloc() {
    return BlocBuilder<AccountAndTransactionCubit, AccountAndTransactionState>(
        builder: (context, state) {
          if (state is AccountAndTransactionInitial) {
            return Container(
                height: 13.70.h * 5.5,
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
                child: buildGroupCompany());
          } else if (state is AccountAndTransactionEmit) {
            String bankCode = context.read<AccountAndTransactionCubit>().getBankCode();
            return BankDetailsNew(bankCode: bankCode);
          }
          return Container();
        });
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

  Future getAccountInfoMethod(String sessionId) async {
  while(true){
    try{
      var getBalance = await WsdlRequest().getAccountInfo("ALL", sessionId);
      Map mapValue = Map<String, dynamic>.from(getBalance);
      if(mapValue["Account"] != null){
        return mapValue;
      }
    }catch(e){
      print(e.toString());
    }
   }
  }

  FutureBuilder buildGetAccountInfoMethodBuilder(String sessionId) {
    return FutureBuilder(
      future: getAccountInfoMethod(sessionId),
      builder: (BuildContext context, snapshot) {
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
                return buildBody(snapshot.data);
              }else if(snapshot.hasError){
                print(snapshot.error);

                return throwErrorWidget();
              }
            }
            return buildBody(snapshot.data);

        }
      },
    );
  }
  Widget throwErrorWidget(){
    return Center(
      child: InkWell(
        onTap: (){
          setState(() {

          });
        },
        child: Container(
          color: Colors.white,
          height: 15.h,
          width: 50.w,
          child: Center(
            child: Column(
              children: [
                Text("Bir hata oluştu!",
                  style: TextStyle(
                      color: AppColors.textFormUnderLineColor,
                      fontSize: LocalHelper.getFontSize(14),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'
                  ),
                ),
                SizedBox(height: 1.7.h,),
                Container(
                  height: 4.5.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFormUnderLineColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text("Tekrar dene"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buildBody(getData) {
    return getData["Account"].runtimeType == List ? ListView.builder(
      itemCount: getData["Account"].length,
      itemBuilder: (context, index) {
        final getCurrency = getData["Account"][index]["CurrencyType"];
        final getIban = getData["Account"][index]["AccountIban"];
        final getAccountBalance = getData["Account"][index]["AvailableBalance"];
        final branchName = getData["Account"][index]["BranchName"];
        final getBankCode = getData["Account"][index]["BankCode"];
        return getCurrency == widget.getCurrency || widget.getCurrency == "TÜMÜ"
            ? buildEachContainer(LocalHelper.getBankLogoString(getBankCode), getIban,
            getAccountBalance, getCurrency, branchName, getBankCode, index)
            : Container();
      },
    ) : ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        final getCurrency = getData["Account"]["CurrencyType"];
        final getIban = getData["Account"]["AccountIban"];
        final getAccountBalance = getData["Account"]["AvailableBalance"];
        final branchName = getData["Account"]["BranchName"];
        final getBankCode = getData["Account"]["BankCode"];

        return getCurrency == widget.getCurrency || widget.getCurrency == "TÜMÜ"
            ? buildEachContainer(LocalHelper.getBankLogoString(getBankCode), getIban,
            getAccountBalance, getCurrency, branchName, getBankCode, index)
            : index == 0 ? Container(
          height: 70.h,
          width: 50.w,
          child: Center(
            child: Text(
              "Hesap bilgisi bulunamadı!",
              style: TextStyle(
                color: AppColors.dismissRedColor,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ) : Container();
      },
    );
  }

  InkWell buildEachContainer(String bankIconPath, String ibanNo,
      String balance, String currency, branchName, getBankCode, index) {
    return InkWell(
      onTap: () => onClickBank(getBankCode),
      child: Container(
        height: 13.05.h,
        padding: EdgeInsets.only(
          bottom: 1.h,
          right: 5.07.w,
          left: 5.07.w,
        ),
        child: buildEachContainerColumn(
            bankIconPath, ibanNo, balance, currency, branchName),
        decoration: BoxDecoration(color: Colors.white),
      ),
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
      branchName == "-" ? "" : branchName,
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
