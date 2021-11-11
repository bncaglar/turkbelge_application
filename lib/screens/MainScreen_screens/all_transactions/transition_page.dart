import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class TransitionPage extends StatefulWidget {
  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  @override
  Widget build(BuildContext context) {
    return buildTransitionPage();
  }

  ListView buildTransitionPage() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(bottom: 1.22.h),
          child: Container(
              height: 17.52.h,
              width: 94.68599033816425.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.allTransactionBoxShadowColor.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: buildBoxColumn()
          ),
        );
      },
    );
  }

  Padding buildBoxColumn() {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.07.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 2.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.textFormUnderLineColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Container(
                height: 4.55.h,
                width: 24.w,
              ),
            ],
          ),
          Container(
            width: 60.49.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppColors.textFormUnderLineColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 1.h,),
          Container(
            width: 24.49.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppColors.textFormUnderLineColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 1.35.h,
          ),
          Center(
            child: Container(
              width: 89.85.w,
              height: 1,
              color: AppColors.allTransactionBoxStraightLineColor,
            ),
          ),
          SizedBox(
            height: 0.95.h,
          ),
          buildRevenue()
        ],
      ),
    );
  }

  Row buildRevenue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRevenueTextColumn(),
        Container(
          height: 5.40.h,
          width: 1,
          color: AppColors.allTransactionBoxStraightLineColor,
        ),
        buildRevenueTextColumn(),
      ],
    );
  }

  Column buildRevenueTextColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        Container(
          height: 0.5.h,
        ),
        Container(
          height: 1.5.h,
          width: 20.w,
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

  Column buildRemainingAmountColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Kalan Bakiye",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(12),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Text(
          "remainingBalance",
          style: TextStyle(
            color: AppColors.infoContentDialogColor,
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
