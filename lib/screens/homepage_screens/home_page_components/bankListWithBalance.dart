import 'package:flutter/material.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/homepage_screens/bank_details/bank_details_page.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class BankListWithBalance extends StatefulWidget {
  @override
  _BankListWithBalanceState createState() => _BankListWithBalanceState();
}

class _BankListWithBalanceState extends State<BankListWithBalance> {
  final log = getLogger();
  @override
  Widget build(BuildContext context) {
    return buildBankListWithBalance();
  }

  Padding buildBankListWithBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        height: 60.h,
        width: 90.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: AppColors.primaryWightColor),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildBankNameAndBalance("3.945,00 TRY", Strings.garanti_icon,
                  BoxFit.cover, "2", "Garanti", "garanti_key_123"),
              buildBankNameAndBalance("5.255,50 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
              buildBankNameAndBalance("8.675,35 TRY", Strings.denizbank_icon,
                  BoxFit.contain, "3", "Denizbank", "denizbank_key_123"),
              buildBankNameAndBalance("1.174,00 TRY", Strings.isbankasi_icon,
                  BoxFit.contain, "1", "İş Bankası", "isbankasi_key_123"),
              buildBankNameAndBalance("9.312,78 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
              buildBankNameAndBalance("9.312,78 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
              buildBankNameAndBalance("9.312,78 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
              buildBankNameAndBalance("9.312,78 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
              buildBankNameAndBalance("9.312,78 TRY", Strings.akbank_icon,
                  BoxFit.contain, "1", "Akbank", "akbank_key_123"),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildBankNameAndBalance(String amount, String imagePath, BoxFit? fitt,
      String numberOfAccount, String bankName, String bankAccountKey) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, BankDetailsPage.routeName,
            arguments: BankDetailsPageArguments(
                bankIcon: imagePath,
                bankName: bankName,
                bankAccountKey: bankAccountKey,
                fitt: fitt));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
        child: Container(
          height: 9.h,
          width: 90.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: AppColors.homepageBankListBackgroundColor,
          ),
          child: buildBankNameAndBalanceRow(
              amount, imagePath, fitt, numberOfAccount),
        ),
      ),
    );
  }

  Row buildBankNameAndBalanceRow(
      String amount, String imagePath, BoxFit? fit, String numberOfAccount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBankImage(imagePath, fit, numberOfAccount),
        buildBankAccountBalance(amount),
      ],
    );
  }

  Row buildBankImage(String imagePath, BoxFit? fitt, String numberOfAccount) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 3.w),
          height: 7.h,
          width: 30.w,
          child: Image.asset(
            imagePath,
            fit: fitt ?? BoxFit.fitWidth,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        Center(
          child: Text(
            "(" + numberOfAccount + " Hesap)",
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(8.5),
              color: AppColors.accountInfoColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }

  Container buildBankAccountBalance(String amount) {
    return Container(
      width: 40.w,
      child: Center(
        child: Text(
          amount,

          ///todo we will get the balance info from api
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(13),
            color: Colors.green,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
