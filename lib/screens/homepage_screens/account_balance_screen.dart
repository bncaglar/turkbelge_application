import 'package:flutter/material.dart';

class AccountBalancePage extends StatefulWidget {
  @override
  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.pink,
      child: Center(
        child: Text("Account Balance Page", style: TextStyle(
            fontSize: 35,
            color: Colors.white
        ),),
      ),
    );
  }
}
