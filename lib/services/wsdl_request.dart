import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class WsdlRequest{
  static WsdlRequest instance = WsdlRequest();

  Future getAccountInfo(String bankCode,String sessionId) async{
    var data;
    do{
     try{
       var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:GetAccountInfo>
         <!--Optional:-->
         <tem:accountRequest>
            <!--Optional:-->
            <tem:SessionID>$sessionId</tem:SessionID>
            <!--Optional:-->
            <tem:BankCode>$bankCode</tem:BankCode>
         </tem:accountRequest>
      </tem:GetAccountInfo>
   </soapenv:Body>
</soapenv:Envelope>
''';
       final String apiEndpoint =
           "https://apiportal.ilekaekstre.com/WebMethods.asmx?op=GetAccountInfo";
       final Uri url = Uri.parse(apiEndpoint);
       http.Response response = await http.post(url,
           headers: {
             "Content-Type": "text/xml; charset=utf-8",
           },
           body: envelope);
       sleep(Duration(milliseconds:500));
       var rawXmlResponse = response.body;
       final Xml2Json xml2Json = Xml2Json();
       xml2Json.parse(rawXmlResponse);
       var jsonString = xml2Json.toParker();
        data = jsonDecode(jsonString);
       return data["soap:Envelope"]["soap:Body"]["BankAccountResponse"]
       ["GetAccountInfoResult"]["AResponseXML"]["ArrayOfAccounts"];
     }catch (e){
       var e ;
     }
    }while(data["soap:Envelope"]["soap:Body"]["BankAccountResponse"]
    ["GetAccountInfoResult"]["Result"]["ResultCode"] != "AP00");
    ///todo we'll check the result code and if the result code is equal to 00 we ll stop the while
    ///otherwise it ll continue requesting
  }

  Future<List?> getTransaction(String sessionId) async{
    try{
      DateTime endDate = DateTime.now();
      String endDateString = endDate.toString().substring(0, 10);
      DateTime startDate = endDate.subtract(const Duration(days: 89));
      String startDateString = startDate.toString().substring(0, 10);
      var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Body>
      <tem:GetTransaction>
         <tem:transactionRequest>
            <tem:StartDate>${startDateString}</tem:StartDate>
            <tem:EndDate>${endDateString}</tem:EndDate>
            <tem:SessionID>$sessionId</tem:SessionID>
            <tem:BankCode>ALL</tem:BankCode>
         </tem:transactionRequest>
      </tem:GetTransaction>
   </soapenv:Body>
</soapenv:Envelope>
''';
      final String apiEndpoint =
          "https://apiportal.ilekaekstre.com/WebMethods.asmx?op=GetTransaction";
      final Uri url = Uri.parse(apiEndpoint);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
          },
          body: envelope);
      sleep(Duration(milliseconds:500));

      var rawXmlResponse = response.body;
      final Xml2Json xml2Json = Xml2Json();
      xml2Json.parse(rawXmlResponse);
      var jsonString = xml2Json.toParker();
      var data = jsonDecode(jsonString);

      return data["soap:Envelope"]["soap:Body"]["BankTransactionResponse"]
      ["GetTransactionResult"]["TResponseXML"]["ArrayOfAccounts"]["Account"];
    }catch (e){
      var e ;
      return e;
    }
  }

  Future getTransactionSorted(String bankCode, String sortString, String sessionId) async{
    var data;
    do{
     try{
       DateTime endDate = DateTime.now();
       String endDateString = endDate.toString().substring(0, 10);
       DateTime startDate = endDate.subtract(const Duration(days: 90));
       String startDateString = startDate.toString().substring(0, 10);
       var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:GetSortedTransaction>
         <!--Optional:-->
         <tem:transactionRequest>
            <!--Optional:-->
            <tem:SessionID>$sessionId</tem:SessionID>
            <!--Optional:-->
            <tem:StartDate>${startDateString}</tem:StartDate>
            <!--Optional:-->
            <tem:EndDate>${endDateString}</tem:EndDate>
            <!--Optional:-->
            <tem:BankCode>$bankCode</tem:BankCode>
            <!--Optional:-->
            <tem:Sorted>${sortString}</tem:Sorted>
         </tem:transactionRequest>
      </tem:GetSortedTransaction>
   </soapenv:Body>
</soapenv:Envelope>
''';
       final String apiEndpoint =
           "https://apiportal.ilekaekstre.com/WebMethods.asmx?op=GetSortedTransaction";
       final Uri url = Uri.parse(apiEndpoint);
       http.Response response = await http.post(url,
           headers: {
             "Content-Type": "text/xml; charset=utf-8",
           },
           body: envelope);
       sleep(Duration(milliseconds:500));

       var rawXmlResponse = response.body;
       final Xml2Json xml2Json = Xml2Json();

       xml2Json.parse(rawXmlResponse);
       var jsonString = xml2Json.toParker();
       data = jsonDecode(jsonString);
       return data["soap:Envelope"]["soap:Body"]["BankSortedTransactionResponse"]
       ["GetSortedTransactionResult"]["STResponseXML"]["ArrayOfTransaction"];
     }catch (e){
       print(e.toString());
     }
    }while(data["soap:Envelope"]["soap:Body"]["BankSortedTransactionResponse"]
    ["GetSortedTransactionResult"]["Result"]["ResultCode"] == "AP00");
  }

  Future getStatisticsTransaction(String startDate, String endDate, String bankCode, String sessionId)async{
    var data;
   do{
      try{
        var envelope = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
   <soap:Header/>
   <soap:Body>
      <tem:GetStatisticsTransaction>
         <tem:request>
            <tem:SessionID>$sessionId</tem:SessionID>
            <tem:BeginDate>$startDate</tem:BeginDate>
            <tem:EndDate>$endDate</tem:EndDate>
            <tem:BankCode>$bankCode</tem:BankCode>
         </tem:request>
      </tem:GetStatisticsTransaction>
   </soap:Body>
</soap:Envelope>
''';
        final String apiEndpoint =
            "https://apiportal.ilekaekstre.com/WebMethods.asmx";
        final Uri url = Uri.parse(apiEndpoint);
        http.Response response = await http.post(url,
            headers: {
              "Content-Type": "text/xml; charset=utf-8",
            },
            body: envelope);
        sleep(Duration(milliseconds:500));

        var rawXmlResponse = response.body;
        final Xml2Json xml2Json = Xml2Json();
        xml2Json.parse(rawXmlResponse);
        var jsonString = xml2Json.toParker();

        data = jsonDecode(jsonString);
        return data["soap:Envelope"]["soap:Body"]["TransactionStatisticsResponse"]["GetStatisticsTransactionResult"]["TSResponseXML"]["ArrayOfTransactionStatistics"];
      }catch(e){
        print(e.toString());
      }
    }while(data["soap:Envelope"]["soap:Body"]["TransactionStatisticsResponse"]["GetStatisticsTransactionResult"]["Result"]["ResultCode"] != "AP00");

  }

  Future getDekontPdf(String transactionIdentifier, String sessionId) async{
    try{
      var envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:GetReceiptResponse>
         <!--Optional:-->
         <tem:receiptRequest>
            <!--Optional:-->
            <tem:SessionID>$sessionId</tem:SessionID>
            <!--Optional:-->
            <tem:ReceiptNo>${transactionIdentifier}</tem:ReceiptNo>
         </tem:receiptRequest>
      </tem:GetReceiptResponse>
   </soapenv:Body>
</soapenv:Envelope>
''';

      final String apiEndpoint =
      "https://apiportal.ilekaekstre.com/WebMethods.asmx?op=GetReceiptResponse";
      final Uri url = Uri.parse(apiEndpoint);
      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
          },
          body: envelope);
      sleep(Duration(milliseconds:500));

      var rawXmlResponse = response.body;
      final Xml2Json xml2Json = Xml2Json();
      xml2Json.parse(rawXmlResponse);
      var jsonString = xml2Json.toParker();
      var data = jsonDecode(jsonString);
      return data["soap:Envelope"]["soap:Body"]["ReceiptResponse"]["GetReceiptResponseResult"];
    }catch(e){

    }
  }

}

