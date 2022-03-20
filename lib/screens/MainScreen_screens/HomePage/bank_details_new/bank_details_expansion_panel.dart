import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class BankDetailsExpansionPanel extends StatefulWidget {
  final String bankCode;
  final String ibanNo;
  final String getAccountAvailableBalance;
  final String currency;
  final String branchName;
  final List<bool> expandedValueList;
  final int index;

  final String getAccountBalance;
  final String getAccountBlockedBalance;
  final String getCreditBalance;
  final String getCreditBalanceUsed;
  final String getCreditAvailableBalance;

  BankDetailsExpansionPanel(
      {required this.bankCode,
      required this.ibanNo,
      required this.getAccountAvailableBalance,
      required this.currency,
      required this.branchName,
      required this.expandedValueList,
      required this.index,
      required this.getAccountBalance,
      required this.getAccountBlockedBalance,
      required this.getCreditBalance,
      required this.getCreditBalanceUsed,
      required this.getCreditAvailableBalance});

  @override
  _BankDetailsExpansionPanelState createState() =>
      _BankDetailsExpansionPanelState();
}

class _BankDetailsExpansionPanelState extends State<BankDetailsExpansionPanel> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  @override
  Widget build(BuildContext context) {
    return buildExpansionPanel(widget.bankCode, widget.ibanNo,
        widget.getAccountAvailableBalance, widget.currency, widget.branchName);
  }

  EnhanceExpansionPanelList buildExpansionPanel(String bankIconPath,
      String ibanNo, String balance, String currency, branchName) {
    return EnhanceExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      animationDuration: Duration(milliseconds: 1000),
      dividerColor: Colors.red,
      elevation: 1,
      children: [
        EnhanceExpansionPanel(
          arrowPosition: EnhanceExpansionPanelArrowPosition.none,
          arrowPadding: EdgeInsets.only(bottom: 1.h),
          canTapOnHeader: true,
          body: buildBodyPanel(balance, currency),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return buildEachContainer(
                bankIconPath, ibanNo, balance, currency, branchName);
          },
          isExpanded: widget.expandedValueList[widget.index],
        )
      ],
      expansionCallback: (int item, bool status) {
        ///todo change value with setState!
        if (widget.expandedValueList[widget.index]) {
          setState(() {
            widget.expandedValueList[widget.index] = false;
          });
        } else {
          setState(() {
            widget.expandedValueList[widget.index] = true;
          });
        }
      },
    );
  }

  Container buildBodyPanel(balance, currency) {
    return Container(

      padding: EdgeInsets.only(
        bottom: 1.h,
        right: 5.07.w,
        left: 5.07.w,
      ),
      child: Column(
        children: <Widget>[
          buildAccountInfoRow("Kullanılabilir Bakiye", balance, currency, 11),
          SizedBox(
            height: 1.h,
          ),
          buildAccountInfoRow("Bakiye", widget.getAccountBalance, currency, 11),
          SizedBox(
            height: 1.h,
          ),
          buildAccountInfoRow(
              "Bloke Bakiye", widget.getAccountBlockedBalance, currency, 11),
          SizedBox(
            height: 1.h,
          ),
          buildAccountInfoRow(
              "Kredi Limiti", widget.getCreditBalance, currency, 11),
          SizedBox(
            height: 1.h,
          ),
          buildAccountInfoRow("Kullanılabilir Kredi Bakiyesi",
              widget.getCreditAvailableBalance, currency, 11),
          SizedBox(
            height: 1.h,
          ),
          buildAccountInfoRow("Kullanılan Kredi Bakiyesi",
              widget.getCreditBalanceUsed, currency, 11),
        ],
      ),
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
        buildAccountInfoRow(ibanNo, balance, currency, 13),
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

  Row buildAccountInfoRow(
      String ibanNo, String balance, String currency, double fontsize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ibanNo,
          style: TextStyle(
              color: AppColors.headerColor,
              fontSize: LocalHelper.getFontSize(fontsize),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400),
        ),
        Text(
          "${oCcy.format(double.parse(balance))} $currency",
          style: TextStyle(
            color: AppColors.accountBalanceColor,
            fontSize: LocalHelper.getFontSize(fontsize),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
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
