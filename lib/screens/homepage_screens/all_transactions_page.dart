import 'package:flutter/material.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.orange,
      child: Center(
        child: Text("Tüm Hareketler", style: TextStyle(
            fontSize: 35,
            color: Colors.white
        ),),
      ),
    );
  }
}
