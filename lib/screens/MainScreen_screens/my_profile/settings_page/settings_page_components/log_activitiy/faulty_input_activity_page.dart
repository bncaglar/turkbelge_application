import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FaultyInputActivityPage extends StatefulWidget {
  @override
  _FaultyInputActivityPageState createState() => _FaultyInputActivityPageState();
}

class _FaultyInputActivityPageState extends State<FaultyInputActivityPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.green.withOpacity(0.05),
                child: buildListTile(index),
              );
            },
          )),
    );
  }

  Container buildListTile(index){
    return Container(
      child: index == 0 ? buildListHeader() : buildIpLog(),
    );
  }
  Container buildListHeader(){
    return Container(
      height: 12.h,
      width: 90.w,
      child: Column(
        children: [
          Container(
            height: 5.h,
            width: 90.w,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 2.h,
                  right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tarih"),
                  Text("Saat"),
                  Text("IP"),
                ],
              ),
            ),
          ),
          buildIpLog(),
        ],
      ),
    );
  }
  Padding buildIpLog(){
    return Padding(padding: EdgeInsets.only(
        right: 5.w,
        left: 5.w
    ),
      child: Container(
        height: 7.h,
        width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("27/09/2021"),
            Text("10:05"),
            Text("176.88.237.180")
          ],
        ),
      ),
    );
  }
}
