import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/routes.dart';
import 'package:turkbelge_application/services/Banks/XmlParse.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

import '../dummyData.dart';

class GetZiraatXmlResponse {
  static GetZiraatXmlResponse instance = GetZiraatXmlResponse();
  FirebaseFirestore? _db = FirebaseFirestore.instance;

  var response = DummyDataResponse.response;

  String _userCollection = "Users";
  String _banks = "Banks";
  String _ziraatBank = "ZiraatBank";

  Future<int?> getNumberOfAccount(String _customerNumber) async {
    int numberOfAccount = (await _db!
            .collection(_userCollection)
            .doc(_customerNumber)
            .collection(_banks)
            .doc("ZiraatBank")
            .get())
        .data()!['NumberOfAccount'];
    return numberOfAccount;
  }

  ///Get StartDate from Firestore
  Future<String> getStartDate(String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_userCollection)
              .doc(_customerNumber)
              .collection(_banks)
              .doc(_ziraatBank)
              .get())
          .data()!['StartDate']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String?> GetZiraatWSDLResponse() async {
    ///Bitiş tarihi DateTime.now alıyoruz
    DateTime endDate = DateTime.now();
    String endDateString =
        endDate.toString().substring(0, 10).replaceRange(2, 2, ".");
    String bankCode = "ZB00";
    String sessionID = "B]Ygv=uZx?jDUV>e1jB*dKJ99%V46E";
    var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Body>
      <tem:GetTransaction>
         <tem:transactionRequest>
            <tem:SessionID>${sessionID}</tem:SessionID>
            <tem:StartDate>2021-06-20 15:00:00</tem:StartDate>
            <tem:EndDate>2021-09-15 15:00:00</tem:EndDate>
            <tem:BankCode>${bankCode}</tem:BankCode>
         </tem:transactionRequest>
      </tem:GetTransaction>
   </soapenv:Body>
</soapenv:Envelope>
''';
    final String apiEndpoint =
        "https://imza.turkbelge.com.tr/AccountTransaction.asmx?op=GetTransaction";
    final Uri url = Uri.parse(apiEndpoint);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
        },
        body: envelope);
    final yarak = Logger();
    var rawXmlResponse = response.body;
    final Xml2Json xml2Json = Xml2Json();
    xml2Json.parse(rawXmlResponse);
    var jsonString = xml2Json.toParker();
    var data = jsonDecode(jsonString);
  //yarak.i(data["soap:Envelope"]["soap:Body"]["BankTransactionResponse"]["GetTransactionResult"]["TResponseXML"]);
    return data["soap:Envelope"]["soap:Body"]["BankTransactionResponse"]["GetTransactionResult"]["TResponseXML"]["ArrayOfAccounts"]["Account"]["AvailableBalance"];
  }
}
