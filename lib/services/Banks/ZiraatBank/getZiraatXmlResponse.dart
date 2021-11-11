import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:xml2json/xml2json.dart';

class GetZiraatXmlResponse {
  static GetZiraatXmlResponse instance = GetZiraatXmlResponse();

  Future<String?> getAvailableBalance(
    String bankCode,
    String sessionID,
  ) async {
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
            <tem:SessionID>${sessionID}</tem:SessionID>
            <tem:BankCode>${bankCode}</tem:BankCode>
         </tem:transactionRequest>
      </tem:GetTransaction>
   </soapenv:Body>
</soapenv:Envelope>
''';
   final String apiEndpoint =
       "https://apiportal.ilekaekstre.com/AccountTransaction.asmx?op=GetTransaction";
   final Uri url = Uri.parse(apiEndpoint);
   http.Response response = await http.post(url,
       headers: {
         "Content-Type": "text/xml; charset=utf-8",
       },
       body: envelope);
   var rawXmlResponse = response.body;
   final Xml2Json xml2Json = Xml2Json();
   xml2Json.parse(rawXmlResponse);
   var jsonString = xml2Json.toParker();
   var data = jsonDecode(jsonString);
   final log = Logger();
   log.i(data);
   return data["soap:Envelope"]["soap:Body"]["BankTransactionResponse"]
   ["GetTransactionResult"]["TResponseXML"]["ArrayOfAccounts"]
   ["Account"]["AvailableBalance"];
 }catch (e){
   return e.toString();
 }
  }
}
