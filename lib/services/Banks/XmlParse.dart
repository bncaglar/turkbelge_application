import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/services/Banks/dummyData.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class XmlParse {
  String? getAccountIban(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      String? ibanNo = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.getElement("AccountIban")
          ?.text;
      print(ibanNo);
      return ibanNo;
    } catch (e) {
      return "Bir hata oluştu";
    }
  }

  String? getBranchName(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      String? branchName = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.getElement("BranchName")
          ?.text;
      return branchName;
    } catch (e) {
      return "Bir hata oluştu";
    }
  }

  String? getAvailableBalance(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      String? availableBalance = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.getElement("AvailableBalance")
          ?.text;
      print(availableBalance);
    } catch (e) {
      return "Bir hata oluştu";
    }
  }

  void ConvertJson() async {
    final log = Logger();
    final Xml2Json xml2Json = Xml2Json();
    xml2Json.parse(DummyDataResponse.response);
    var jsonString = xml2Json.toParker();
    var data = jsonDecode(jsonString);

   log.i(data["BankTransactionResponse"]["ArrayOfAccounts"]["Account"][0]["AvailableBalance"].runtimeType);

  }

  Iterable<List<XmlElement>>? getTransactionIbanAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionIban").toList());
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getTransactionDateTime(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfDateTimes = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionDateTime").toList());
      return arrayOfDateTimes;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getTransactionName(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransactionNames = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionName").toList());
      return arrayOfTransactionNames;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getTransactionAmountAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionAmount").toList());
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getTransactionDescriptionAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionDescription").toList());
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getTransactionCodeAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("TransactionCode").toList());
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getBorcAlacakAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("BorcAlacak").toList());
      List? x = arrayOfTransaction?.iterator.current;
      print("swd");
      print(x);
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }

  Iterable<List<XmlElement>>? getCurrencyTypeAsList(String response) {
    try {
      XmlDocument? xml = XmlDocument.parse(response);
      var arrayOfTransaction = xml
          .getElement("BankTransactionResponse")
          ?.getElement("ArrayOfAccounts")
          ?.getElement("Account")
          ?.findAllElements("ArrayOfTransactions")
          .map((e) => e.findAllElements("CurrencyType").toList());
      return arrayOfTransaction;
    } catch (e) {
      var e;
      return e;
    }
  }
}
