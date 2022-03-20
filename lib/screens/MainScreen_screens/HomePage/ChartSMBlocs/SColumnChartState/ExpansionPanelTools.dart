import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

// ignore: must_be_immutable
class ExpansionPanelTools extends StatefulWidget {
  var getData;
  var getDailyInfoData;
  var getStatisticsData;
  String getStatisticTimeString;
  String currency;
  List<bool> expandedValueList;

  ExpansionPanelTools(
      {required this.getStatisticTimeString,
      required this.getStatisticsData,
      required this.expandedValueList,
      required this.currency,
      required this.getData,
      required this.getDailyInfoData});

  @override
  _ExpansionPanelToolsState createState() => _ExpansionPanelToolsState();
}

class _ExpansionPanelToolsState extends State<ExpansionPanelTools> {
  final log = Logger();
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  @override
  Widget build(BuildContext context) {
    return buildListView(widget.getData, widget.currency);
  }

  int calculateNumberOfCount(getData) {
    if (getData != null) {
      if (getData["Account"].runtimeType == List) {
        return getData["Account"].length;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }

  ListView buildListView(getData, String currency) {
    int itemCount = calculateNumberOfCount(getData);
    List list = [];
    return ListView.builder(
      padding: EdgeInsets.only(top: 1.08.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (getData["Account"].runtimeType == List) {
          if (getData["Account"][index]["CurrencyType"] == currency) {
            final bankCode = getData["Account"][index]["BankCode"];
            final balanceList = getData["Account"][index]["AvailableBalance"];
            final getCurrency = getData["Account"][index]["CurrencyType"];
            int numberOfAcc = numberOfAccMethod(getData, bankCode, currency);
            for (int i = 0; i < getData["Account"].length; i++) {
              if (!list.contains(getData["Account"][i]["BankCode"])) {
                if (getCurrency == currency) {
                  list.add(getData["Account"][index]["BankCode"]);
                  if (list.length > 1) {
                    if (list.contains(getData["Account"][i]["BankCode"])) {
                      return buildExpansionPanel(index, bankCode, balanceList,
                          getCurrency, numberOfAcc, getData, currency);
                    }
                  } else {
                    if (list.contains(getData["Account"][i]["BankCode"])) {
                      return buildExpansionPanel(index, bankCode, balanceList,
                          getCurrency, numberOfAcc, getData, currency);
                    }
                  }
                }
              }
            }
            return Container();
          } else {
            return Container();
          }
        } else {
          if (getData["Account"]["CurrencyType"] == currency) {
            final bankCode = getData["Account"]["BankCode"];
            final balanceList = getData["Account"]["AvailableBalance"];
            final getCurrency = getData["Account"]["CurrencyType"];
            return buildExpansionPanel(index, bankCode, balanceList,
                getCurrency, 1, getData, currency);
          } else {
            return Container();
          }
        }
      },
    );
  }

  int numberOfAccMethod(getData, bankCode, currency) {
    try {
      int accNo = 0;
      if (getData["Account"].runtimeType == List) {
        for (int i = 0; i < getData["Account"].length; i++) {
          if (getData["Account"][i]["CurrencyType"] == currency) {
            if (getData["Account"][i]["BankCode"] == bankCode) {
              accNo += 1;
            }
          }
        }
      } else {
        accNo = 1;
      }
      return accNo;
    } catch (e) {
      return 0;
    }
  }

  Padding buildExpansionPanel(index, bankCode, balanceList, currency,
      numberOfAccount, getData, currencyBloc) {
    return Padding(
      padding: EdgeInsets.only(right: 7.24.w, left: 7.24.w, top: 1.08.h),
      child: EnhanceExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        animationDuration: Duration(milliseconds: 1000),
        dividerColor: Colors.red,
        elevation: 2,
        children: [
          EnhanceExpansionPanel(
              arrowPosition: EnhanceExpansionPanelArrowPosition.none,
              arrowPadding: EdgeInsets.only(bottom: 1.h),
              canTapOnHeader: true,
              body: Container(
                height: numberOfAccount * 7.45.h,
                width: 92.02.w,
                decoration: BoxDecoration(
                  color: index.floor().isEven
                      ? AppColors.columnChartHalfDownContainerColor
                      : AppColors.primaryWightColor,
                  border: Border.all(
                      color: AppColors.columnChartHalfDownContainerBorderColor),
                ),
                child: buildBody(
                    numberOfAccount, getData, index, currencyBloc, bankCode),
              ),
              headerBuilder: (BuildContext context, bool isExpanded) {
                return buildHeaderContainer(bankCode, numberOfAccount,
                    balanceList, currency, index, getData);
              },
              isExpanded: widget.expandedValueList[index],
              backgroundColor: index.floor().isEven
                  ? AppColors.primaryWightColor
                  : AppColors.columnChartHalfDownContainerColor),
        ],
        expansionCallback: (int item, bool status) {
          if (widget.expandedValueList[index]) {
            setState(() {
              widget.expandedValueList[index] = false;
            });
          } else {
            setState(() {
              widget.expandedValueList[index] = true;
            });
          }
        },
      ),
    );
  }

  Container buildHeaderContainer(String bankCode, numberOfAcc, balanceList,
      String currency, index, getData) {
    double transactionAverageValue = getTransactionAverageValue(getData, index);
    return Container(
      height: 8.69.h,
      width: 92.02.w,
      decoration: BoxDecoration(
        color: index.floor().isEven
            ? AppColors.primaryWightColor
            : AppColors.columnChartHalfDownContainerColor,
        border: Border.all(
          color: AppColors.columnChartHalfDownContainerBorderColor,
        ),
      ),
      child: Row(
        children: [
          buildBankLogo(bankCode, numberOfAcc),
          Spacer(),
          buildRightSide(
              balanceList, currency, transactionAverageValue, bankCode),
          Container(
            width: 10.62.w,
            height: 8.69.h,
            child: Center(
              child: SvgPicture.asset(
                widget.expandedValueList[index]
                    ? "svg/arrow_down_svg.svg"
                    : "svg/arrow.svg",
                color: AppColors.textFormUnderLineColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildRightSide(
      balanceList, String currency, transactionStatisticValue, bankCode) {
    return Padding(
      padding: EdgeInsets.only(top: 2.17.h, right: 2.22.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildBalance(balanceList, currency),
          Row(
            children: [
              buildRevenueTextRow(transactionStatisticValue, currency),
              SizedBox(
                width: 1.44.w,
              ),
              buildPercentageRow(
                  balanceList, currency, bankCode, transactionStatisticValue),
            ],
          )
        ],
      ),
    );
  }

  double buildPercentageValueForAccount(
      balance, currency, accountIdentifier, incomeValue) {
    try {
      double total = 0;
      double currentBalance = double.parse(balance);
      double availableBalance = 0;
      if (widget.getDailyInfoData != "null") {
        var dailyData = widget.getDailyInfoData["AResponseXML"]
            ["ArrayOfAccounts"]["Account"];
        for (int i = 0; i < dailyData.length; i++) {
          if (dailyData[i]["CurrencyType"] == currency &&
              dailyData[i]["AccountIdentifier"] == accountIdentifier) {
            availableBalance = double.parse(dailyData[i]["AvailableBalance"]);
            total = (availableBalance * 100) / currentBalance;

            if (availableBalance < currentBalance) {
              total = total * -1;
            }
            if (incomeValue == 0) {
              total = 0;
            }
            if (availableBalance == 0 && currentBalance > 1) {
              total = 100;
            }
          }
        }
        if (total.isNaN || total.isInfinite) {
          return 0;
        } else {
          return total;
        }
      } else {
        return 0;
      }
    } catch (err) {
      log.wtf(err);
      return 0;
    }
  }

  double buildPercentageValue(balance, currency, bankCode, incomeValue) {
    try {
      double total = 0;
      double currentBalance = double.parse(balance);
      double availableBalance = 0;
      if (widget.getDailyInfoData != "null") {
        var dailyData = widget.getDailyInfoData["AResponseXML"]
            ["ArrayOfAccounts"]["Account"];
        for (int i = 0; i < dailyData.length; i++) {
          if (dailyData[i]["CurrencyType"] == currency &&
              dailyData[i]["BankCode"] == bankCode) {
            availableBalance = availableBalance +
                double.parse(dailyData[i]["AvailableBalance"]);
            total = (incomeValue * 100) / currentBalance;
            if (availableBalance < currentBalance) {
              total = total * -1;
            }
            if (incomeValue == 0) {
              total = 0;
            }
          }
        }
        if (total.isNaN || total.isInfinite) {
          return 0;
        } else {
          return total;
        }
      } else {
        log.i("err");
        return 0;
      }
    } catch (err) {
      log.wtf(err.toString());
      return 0;
    }
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

  ListView buildBody(
      numberOfAccount, getData, indexOfPrev, currencyBlocs, bankCode) {
    return getData["Account"].runtimeType == List
        ? ListView.builder(
            itemCount: getData["Account"].length,
            itemBuilder: (context, index) {
              final branchName = getData["Account"][index]["BranchName"];
              final ibanNumber = getData["Account"][index]["AccountIban"];
              final borcAlacak = getData["Account"][index]["BorcAlacak"];
              final getCurrency = getData["Account"][index]["CurrencyType"];
              if (getCurrency == currencyBlocs) {
                if (getData["Account"][index]["BankCode"] ==
                    getData["Account"][indexOfPrev]["BankCode"]) {
                  return dropDownColumn(numberOfAccount, branchName, ibanNumber,
                      getData, index, getCurrency, borcAlacak, indexOfPrev);
                }
              }
              return Container();
            },
          )
        : ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              final branchName = getData["Account"]["BranchName"];
              final ibanNumber = getData["Account"]["AccountIban"];
              final borcAlacak = getData["Account"]["BorcAlacak"];

              final getCurrency = getData["Account"]["CurrencyType"];
              if (getCurrency == currencyBlocs) {
                if (getData["Account"]["BankCode"] ==
                    getData["Account"]["BankCode"]) {
                  return dropDownColumn(numberOfAccount, branchName, ibanNumber,
                      getData, index, getCurrency, borcAlacak, indexOfPrev);
                }
              }
              return Container();
            },
          );
  }

  double getTransactionAverageValue(getData, index) {
    double gelirDeger = 0;
    double giderDeger = 0;
    double toplam = 0;

    try {
      if (widget.getStatisticsData != "null") {
        if (widget.getStatisticsData["TransactionStatistics"].runtimeType ==
            List) {
          ///statistic data is not a single element!
          if (getData["Account"].runtimeType == List) {
            for (int x = 0;
                x < widget.getStatisticsData["TransactionStatistics"].length;
                x++) {
              if (getData["Account"][index]["BankCode"] ==
                  widget.getStatisticsData["TransactionStatistics"][x]
                      ["BankCode"]) {
                if (widget.getStatisticsData["TransactionStatistics"][x]
                        ["BorcAlacak"] ==
                    "A") {
                  gelirDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"][x]["Amount"]);
                } else {
                  giderDeger = double.parse(
                          widget.getStatisticsData["TransactionStatistics"][x]
                              ["Amount"]) *
                      -1;
                }
              }
            }
          } else {
            for (int x = 0;
                x < widget.getStatisticsData["TransactionStatistics"].length;
                x++) {
              if (getData["Account"]["BankCode"] ==
                  widget.getStatisticsData["TransactionStatistics"][x]
                      ["BankCode"]) {
                if (widget.getStatisticsData["TransactionStatistics"][x]
                        ["BorcAlacak"] ==
                    "A") {
                  gelirDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"][x]["Amount"]);
                } else {
                  giderDeger = double.parse(
                          widget.getStatisticsData["TransactionStatistics"][x]
                              ["Amount"]) *
                      -1;
                }
              }
            }
          }
        } else {
          ///statistic data is a single element!
          if (getData["Account"]["BankCode"] ==
              widget.getStatisticsData["TransactionStatistics"]["BankCode"]) {
            if (widget.getStatisticsData["TransactionStatistics"]
                    ["BorcAlacak"] ==
                "A") {
              gelirDeger = double.parse(
                  widget.getStatisticsData["TransactionStatistics"]["Amount"]);
            } else {
              giderDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"]["Amount"]) *
                  -1;
            }
          }
        }
        toplam = gelirDeger + giderDeger;
        return toplam;
      } else {
        return 0;
      }
    } catch (e) {
      log.e(e.toString());
      return 0;
    }
  }

  double calculateIncome(getData, index, indexOfPrev) {
    double gelirDeger = 0;
    double giderDeger = 0;
    double toplam = 0;
    try {
      if (widget.getStatisticsData != "null") {
        if (widget.getStatisticsData["TransactionStatistics"].runtimeType ==
            List) {
          ///statistic data is not a single element!
          if (getData["Account"].runtimeType == List) {
            for (int x = 0;
                x < widget.getStatisticsData["TransactionStatistics"].length;
                x++) {
              if (getData["Account"][index]["AccountIdentifier"] ==
                  widget.getStatisticsData["TransactionStatistics"][x]
                      ["AccountIdentifier"]) {
                if (widget.getStatisticsData["TransactionStatistics"][x]
                        ["BorcAlacak"] ==
                    "A") {
                  gelirDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"][x]["Amount"]);
                } else {
                  giderDeger = double.parse(
                          widget.getStatisticsData["TransactionStatistics"][x]
                              ["Amount"]) *
                      -1;
                }
              }
            }
          } else {
            for (int x = 0;
                x < widget.getStatisticsData["TransactionStatistics"].length;
                x++) {
              if (getData["Account"]["AccountIdentifier"] ==
                  widget.getStatisticsData["TransactionStatistics"][x]
                      ["AccountIdentifier"]) {
                if (widget.getStatisticsData["TransactionStatistics"][x]
                        ["BorcAlacak"] ==
                    "A") {
                  gelirDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"][x]["Amount"]);
                } else {
                  giderDeger = double.parse(
                          widget.getStatisticsData["TransactionStatistics"][x]
                              ["Amount"]) *
                      -1;
                }
              }
            }
          }
        } else {
          ///statistic data is a single element!
          if (getData["Account"]["AccountIdentifier"] ==
              widget.getStatisticsData["TransactionStatistics"]
                  ["AccountIdentifier"]) {
            if (widget.getStatisticsData["TransactionStatistics"]
                    ["BorcAlacak"] ==
                "A") {
              gelirDeger = double.parse(
                  widget.getStatisticsData["TransactionStatistics"]["Amount"]);
            } else {
              giderDeger = double.parse(widget
                      .getStatisticsData["TransactionStatistics"]["Amount"]) *
                  -1;
            }
          }
        }
        toplam = gelirDeger + giderDeger;
        return toplam;
      } else {
        return 0;
      }
    } catch (e) {
      log.e(e.toString());
      return 0;
    }
  }

  Column dropDownColumn(numberOfAccount, branchName, ibanNumber, getData, index,
      getCurrency, borcAlacak, indexOfPrev) {
    double incomeValue = calculateIncome(
      getData,
      index,
      indexOfPrev,
    );
    return Column(
      children: [
        SizedBox(
          height: 0.5.h,
        ),
        Container(
          height: 6.92.h,
          width: 92.02.w,
          decoration: BoxDecoration(
              color: AppColors.primaryWightColor,
              border: Border.all(
                  color: AppColors.columnChartHalfDownContainerBorderColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 3.36.w,
              ),
              Container(
                height: 4.89.h,
                width: 1.20.w,
                decoration: BoxDecoration(
                  color: AppColors.textFormUnderLineColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              SizedBox(
                width: 2.65.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ibanNumber,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.headerColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    branchName,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: LocalHelper.getFontSize(10),
                        color: AppColors.infoContentDialogColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPercentageRowForAccount(
                      getData["Account"][index]["AvailableBalance"],
                      getCurrency,
                      getData["Account"][index]["AccountIdentifier"],
                      incomeValue),
                  buildRevenueTextColumn(incomeValue, borcAlacak, getCurrency),
                ],
              ),
              SizedBox(
                width: 3.86.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildRevenueTextRow(amount, currency) {
    return Row(
      children: [
        Text(
          amount == 0 ? "":  amount > 1 ? "+ " : "",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(10),
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              amount == 0 ? "-":  oCcy.format(amount),
              style: TextStyle(
                color: AppColors.infoContentDialogColor,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(10),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              amount == 0 ? "" :LocalHelper.getCurrencyMethod(currency),
              style: TextStyle(
                color: AppColors.infoContentDialogColor,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(10),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row buildRevenueTextColumn(amount, borcAlacak, currency) {
    return Row(
      children: [
        Text(
          amount > 1 ? "+ " : "",
          style: TextStyle(
            color: amount > 1
                ? AppColors.allTransactionGelirColor
                : amount == 0
                    ? AppColors.infoContentDialogColor
                    : AppColors.SignInColorGradientStart,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(11),
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              amount == 0 ? "-" : oCcy.format(amount),
              style: TextStyle(
                color: amount > 1
                    ? AppColors.allTransactionGelirColor
                    : amount == 0
                        ? AppColors.infoContentDialogColor
                        : AppColors.SignInColorGradientStart,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(11),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              amount == 0 ? "" : LocalHelper.getCurrencyMethod(currency),
              style: TextStyle(
                color: amount > 1
                    ? AppColors.allTransactionGelirColor
                    : amount == 0
                        ? AppColors.infoContentDialogColor
                        : AppColors.SignInColorGradientStart,
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(11),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row buildPercentageRowForAccount(
      balance, currency, accountIdentifier, incomeValue) {
    double percentage = buildPercentageValueForAccount(
        balance, currency, accountIdentifier, incomeValue);
    return Row(
      children: [
        percentage == 0
            ? Container()
            : SvgPicture.asset(
                percentage < 1 ? "svg/UnPolygon.svg" : "svg/Polygon.svg",
                color: percentage < 1
                    ? AppColors.SignInColorGradientStart
                    : AppColors.allTransactionGelirColor,
              ),
        SizedBox(
          width: 1.44.w,
        ),
        Text(
          percentage == 0
              ? "-"
              : "${percentage.toString().substring(0, percentage.toString().length < 5 ? percentage.toString().length : 5)}%",
          style: percentage == 0
              ? TextStyle(
                  color: AppColors.infoContentDialogColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(11),
                )
              : TextStyle(
                  color: percentage < 1
                      ? AppColors.SignInColorGradientStart
                      : AppColors.allTransactionGelirColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(11),
                ),
        ),
      ],
    );
  }

  Row buildPercentageRow(balance, currency, bankCode, incomeValue) {
    double percentage =
        buildPercentageValue(balance, currency, bankCode, incomeValue);
    return Row(
      children: [
        percentage == 0
            ? Container(): SvgPicture.asset(
          percentage < 1 ? "svg/UnPolygon.svg" : "svg/Polygon.svg",
          color: percentage < 1
              ? AppColors.SignInColorGradientStart
              : AppColors.allTransactionGelirColor,
        ),
        SizedBox(
          width: 1.44.w,
        ),
        Text(
          percentage == 0
              ? "-"
              : "${percentage.toString().substring(0, percentage.toString().length < 5 ? percentage.toString().length : 5)}%",
          style: percentage == 0
              ? TextStyle(
                  color: AppColors.infoContentDialogColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(11),
                )
              : TextStyle(
                  color: percentage < 1
                      ? AppColors.SignInColorGradientStart
                      : AppColors.allTransactionGelirColor,
                  fontFamily: 'Poppins',
                  fontSize: LocalHelper.getFontSize(11),
                ),
        ),
      ],
    );
  }

  Padding buildBankLogo(String bankCode, numberOfAcc) {
    return Padding(
      padding: EdgeInsets.only(left: 2.22.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 23.42.w,
            height: 5.16.h,
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

  Container buildBodyContainer(numberOfAccount) {
    return Container(
      color: Colors.black,
      height: numberOfAccount * 6.09.h,
      width: 92.06.w,
    );
  }
}
