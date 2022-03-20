import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class LogInActivityProper extends StatefulWidget {
  @override
  _LogInActivityProperState createState() => _LogInActivityProperState();
}

class _LogInActivityProperState extends State<LogInActivityProper> {

  @override
  Widget build(BuildContext context) {
    double totalHeight = 12.63.h * 5;
    return Container(
      padding: EdgeInsets.only(
        top: 1.90.h,
        right: 2.65.w,
        left: 2.65.w,
      ),
      height: totalHeight,
      child: buildListView(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4),),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.13),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
  ListView buildListView(){
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index){
        return buildEachBox();
      },
    );
  }

  Container buildEachBox(){
    return Container(
      height: 12.63.h,
      width: 94.68.w,
      color: AppColors.primaryWightColor,
      child: Column(
        children: [
          buildStraightLine(),
        ],
      ),
    );
  }

  Container buildStraightLine(){
    return Container(
      height: 1,
      width: 89.85.w,
      color: AppColors.allTransactionBoxStraightLineColor,
    );
  }
}
