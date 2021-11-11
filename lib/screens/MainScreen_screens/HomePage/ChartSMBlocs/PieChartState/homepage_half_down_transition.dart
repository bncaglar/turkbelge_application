import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class HomePagePieChartStateTransition extends StatefulWidget {
  final bool isPie;
  HomePagePieChartStateTransition({
    required this.isPie
});
  @override
  _HomePagePieChartStateTransitionState createState() => _HomePagePieChartStateTransitionState();
}

class _HomePagePieChartStateTransitionState extends State<HomePagePieChartStateTransition> {
  final oCcy = new NumberFormat("#,##0.00", "tr_TR");

  @override
  Widget build(BuildContext context) {
    return buildListView();
  }

  ListView buildListView(){
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 3.h
      ),
      itemCount: 5,
      itemBuilder: (context, index){
        return buildEachBankRow();
      },
    );
  }
  Padding buildEachBankRow(){
    return Padding(
      padding: EdgeInsets.only(
          right: 7.24.w, left: 7.24.w),
      child: Container(
        height: 7.20.h,
        color: AppColors.primaryWightColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBankAccountRow(),
                Spacer(),
                buildAccountBalance(),
              ],
            ),
            Container(
              height: 1,
              width: 84.54.w,
              color: AppColors.textFormUnderLineColor,
            )
          ],
        ),
      ),
    );
  }

  Row buildBankAccountRow(){
    return Row(
      children: <Widget>[
       widget.isPie ?  buildBankColor() : Container(),
        buildBankInfoColumn()
      ],
    );
  }

  Column buildBankInfoColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1.5.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: AppColors.textFormUnderLineColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 1.h, width: 42.43.w,),
        Container(
          height: 1.5.h,
          width: 15.w,
          decoration: BoxDecoration(
            color: AppColors.textFormUnderLineColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildBankColor(){
    return Padding(
      padding: EdgeInsets.only(
          right: 2.17.w,
          bottom: 1.15.h,
          top: 1.15.h
      ),
      child: Container(
        height: 4.75.h,
        width: 1.44.w,
        decoration: BoxDecoration(
          color: AppColors.textFormUnderLineColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }



  Row buildAccountBalance(){
    return Row(
      children: [
        Container(
          height: 1.5.h,
          width: 25.w,
          decoration: BoxDecoration(
            color: AppColors.textFormUnderLineColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        SizedBox(width: 1.w,),

      ],
    );
  }

}
