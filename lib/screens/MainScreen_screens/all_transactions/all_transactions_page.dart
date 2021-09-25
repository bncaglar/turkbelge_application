import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/services/Banks/dummyData.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:xml2json/xml2json.dart';

class AllTransactionsPage extends StatefulWidget {
  final String getCurrency;

  AllTransactionsPage({required this.getCurrency});

  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  final log = getLogger();
  ScrollController _listViewController = ScrollController();

  onClickTap() {

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: FutureBuilder(
            future: getTransactionHistoryAll(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return circularProgresState();
                default:
                  if (snapshot.hasError)
                    return couldNotLoadedState();
                  else {
                    int transactionLength = snapshot
                        .data["BankTransactionResponse"]["ArrayOfAccounts"]
                            ["Account"]["ArrayOfTransactions"]
                        .length;
                    final data = snapshot.data["BankTransactionResponse"]
                        ["ArrayOfAccounts"]["Account"]["ArrayOfTransactions"];
                    Timer(
                        Duration(milliseconds: 00),
                            () => {
                          _listViewController
                              .jumpTo(_listViewController.position.maxScrollExtent),
                        });
                    return TransactionPageListView(transactionLength, data,_listViewController);
                  }
              }
            }),
      ),
    );
  }

  Scaffold circularProgresState() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Scaffold couldNotLoadedState() {
    return Scaffold(
      body: Center(
        child: Text("Tüm Hareketler Yüklenemedi!"),
      ),
    );
  }

  ListView TransactionPageListView(int itemCount, data,_listViewController) {
    return ListView.separated(
      controller: _listViewController,
        reverse: true,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (BuildContext context, int index) {
          final item = data[index];

          if (widget.getCurrency == "TÜMÜ") {
            return seperateBuilderContainer(data, index);
          } else if (widget.getCurrency == "TRY") {
            if (item["CurrencyType"] == "TRY") {
              return seperateBuilderContainer(data, index);
            }
          } else if (widget.getCurrency == "USD") {
            if (item["CurrencyType"] == "USD") {
              return seperateBuilderContainer(data, index);
            }
          } else if (widget.getCurrency == "EUR") {
            if (item["CurrencyType"] == "EUR") {
              return seperateBuilderContainer(data, index);
            }
          }
          return Container();
        },
        itemBuilder: (context, index) {
          final item = data[index];
          if (widget.getCurrency == "TÜMÜ") {
            return buildSlidable(item);
          } else if (widget.getCurrency == "TRY") {
            if (item["CurrencyType"] == "TRY") {
              return buildSlidable(item);
            }
          } else if (widget.getCurrency == "USD") {
            if (item["CurrencyType"] == "USD") {
              return buildSlidable(item);
            }
          } else if (widget.getCurrency == "EUR") {
            if (item["CurrencyType"] == "EUR") {
              return buildSlidable(item);
            }
          }
          return Container();
        });
  }

  Container buildSlidable(item) {
    return Container(
        color: Colors.green.withOpacity(0.08),
        child: Slidable(
          actionPane: SlidableStrechActionPane(),
          actionExtentRatio: 0.25,
          child: buildListTile(item),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Daha Fazla',
              color: Colors.black45,
              icon: Icons.more_horiz,
            ),
            IconSlideAction(
              caption: 'Arşiv',
              color: Colors.blue,
              icon: Icons.archive,
            ),
            IconSlideAction(
              caption: 'Paylaş',
              color: Colors.indigo,
              icon: Icons.share,
            ),
          ],
        ));
  }

  Widget buildListTile(item) => ListTile(
        onTap: () {
          onClickTap();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        leading: leadingOfListTile(item),
        subtitle: subtitleOfListTile(item),
        title: titleOfListTile(item),
        trailing: trailingOfListTile(item),
      );

  Column trailingOfListTile(item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item["TransactionAmount"] + " " + item["CurrencyType"],
          style: TextStyle(
              color: item["BorcAlacak"] == "B" ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold),
        ),
        Container(
          height: 2.h,
          width: 27.w,
          child: Row(
            children: [
              Text(
                "Kalan Bakiye: ",
                style: TextStyle(
                    color: AppColors.bottomNavigationBarColor, fontSize: 10),
              ),
              Text(item["RemainingBalance"].toString().trim() + " ",
                  style: TextStyle(
                      color: AppColors.accountInfoColor, fontSize: 12)),
            ],
          ),
        )
      ],
    );
  }

  Text titleOfListTile(item) {
    return Text(
      item["TransactionName"],
      style: TextStyle(color: AppColors.accountInfoColor, fontSize: 13),
    );
  }

  Container subtitleOfListTile(item) {
    return Container(
      height: 4.h,
      width: 80.w,
      child: Text(
        item["TransactionDescription"],
        style:
            TextStyle(color: AppColors.bottomNavigationBarColor, fontSize: 12),
      ),
    );
  }

  Container leadingOfListTile(item) {
    return Container(
      height: 10.h,
      width: 11.w,
      child: Column(
        children: [
          Container(
            height: 6.h,
            child: Image.asset(
              Strings.akbank_square_logo,
              fit: BoxFit.fitWidth,
            ),
          ),
          transactionDateTimeText(item),
        ],
      ),
    );
  }

  Container transactionDateTimeText(item) {
    return Container(
      height: 2.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          DateFormat("HH:mm").format(DateFormat("HH:mm:ss aaa")
              .parse(item["TransactionDateTime"].toString().substring(10))),
          style: TextStyle(
              color: AppColors.textPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding seperateBuilderContainer(data, index) {
    if (data[index]["TransactionDateTime"].toString().substring(0, 9) !=
        data[index + 1]["TransactionDateTime"].toString().substring(0, 9)) {
      return Padding(
        padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
        child: transactionDateDivider(data, index),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
        child: Container(),
      );
    }
  }

  Container transactionDateDivider(data, index) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Container(
          height: 3.h,
          width: 20.w,
          child: Center(
              child: Text(data[index]["TransactionDateTime"]
                  .toString()
                  .substring(0, 9))),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1),
            ],
          ),
        ),
      ),
    );
  }

  Future getTransactionHistoryAll() async {
    final Xml2Json xml2Json = Xml2Json();
    xml2Json.parse(DummyDataResponse.response);
    var jsonString = xml2Json.toParker();
    var data = jsonDecode(jsonString);
    return data;
  }
}
