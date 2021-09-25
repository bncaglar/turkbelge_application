import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BankAccountsSummary extends StatefulWidget {
  final String bankCode;

  BankAccountsSummary({required this.bankCode});

  @override
  _BankAccountsSummaryState createState() => _BankAccountsSummaryState();
}

class _BankAccountsSummaryState extends State<BankAccountsSummary> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                    color: Colors.green.withOpacity(0.08),
                    child: buildListTile(),);
          })
      ),
    );
  }

  Widget buildListTile() => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
    subtitle: Text("BUCA/İZMİR ŞUBESİ"),
    title: Text("TR440001000711829964725001"),
    trailing: Text("25.63 TL"),
  );

// FutureBuilder buildBankAccountsSummaryBody() {
//   return FutureBuilder(
//     future: checkBankInfo(),
//     builder: (){
//
//     },
//   );
// }
// Future checkBankInfo() async {
//   switch(widget.bankCode){
//     case "ZB00":
//
//       break;
//     case "GB00":
//
//       break;
//   }
// }
//
// ListView buildListView(){
//   return ListView(
//
//   );
// }
}
