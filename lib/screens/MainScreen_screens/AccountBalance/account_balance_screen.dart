import 'package:flutter/material.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class AccountBalancePage extends StatefulWidget {
  final String getCurrency;

  AccountBalancePage({required this.getCurrency});

  @override
  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  List listofAccount = [
    "Akbank",
    "Garanti Bankası",
    "Denizbank",
    "İş Bankası",
  ];
  List listOfBankIcon = [
    Strings.akbank_icon,
    Strings.garanti_icon,
    Strings.denizbank_icon,
    Strings.isbankasi_icon
  ];

  List listOfCurrency = ["TRY", "EUR", "TRY", "USD"];
  List listOfBalance = ["15.485,50", "7.502,00", "522,00", "78.250,00"];
  List listOfIban = ["TR570001000606000066667310","TR440001000711829964725001","TR480006200086500006295003","TR320001000606000066667310"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(
            listofAccount, listOfBankIcon, listOfCurrency, listOfBalance,listOfIban),
      ),
    );
  }

  Container buildAppBar() {
    return Container(
      height: 10.h,
      width: double.infinity,
      color: AppColors.newColor4Background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLeadingIcon(),
          buildHeaderText(),
          buildTrailingIcon(),
        ],
      ),
    );
  }

  IconButton buildLeadingIcon() {
    return IconButton(
      icon: Icon(
        Icons.sort,
        color: Colors.white,
      ),
      onPressed: () {
        ///todo sort the list of balance
      },
    );
  }

  Text buildHeaderText() {
    return Text(
      "HESAP BAKİYESİ",
      style:
          TextStyle(color: Colors.white, fontSize: LocalHelper.getFontSize(15)),
    );
  }

  IconButton buildTrailingIcon() {
    return IconButton(
      icon: Icon(
        Icons.filter_alt_rounded,
        color: Colors.white,
      ),
      onPressed: () {
        ///todo sort the list of balance
      },
    );
  }

  Container buildBody(
      listofAccount, listOfBankIcon, listOfCurrency, listOfBalance,listOfIban) {
    return Container(
      height: 78.h,
      width: 100.w,
      child: ListView.builder(
        itemCount: listofAccount.length,
        itemBuilder: (context, index) {
          final accountItem = listofAccount[index];
          final iconItem = listOfBankIcon[index];
          final getCurrency = listOfCurrency[index];
          final getAccountBalance = listOfBalance[index];
          final getIban = listOfIban[index];
          return Container(
              color: Colors.green.withOpacity(0.08),
              child: buildListTile(
                  accountItem, iconItem, getCurrency, getAccountBalance,getIban),);
        },
      ),
    );
  }

  Widget buildListTile(accountItem, iconItem, getCurrency, getAccountBalance,getIban) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        leading: leadingOfListTile(iconItem),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BUCA/İZMİR ŞUBESİ"),
            Text(getIban),
          ],
        ),
        title: Text(accountItem),
        trailing: Text(
          "$getAccountBalance $getCurrency",
          style: TextStyle(color: Colors.green),
        ),
      );

  Container leadingOfListTile(iconItem) {
    return Container(
      height: 10.h,
      width: 11.w,
      child: Container(
        height: 6.h,
        child: Image.asset(
          iconItem,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
