import 'package:flutter/material.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/PieChartState/pie_chart_customer_painter.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  double total = 0;

  @override
  void initState() {
    super.initState();
    category.forEach((e) => total += e['amount']);
  }

  List category = [
    {"name": "Garanti", "amount": 3526},
    {"name": "Akbank", "amount": 5023},
    {"name": "DenizBank", "amount": 9332},
    {"name": "Türkiye İş Bankası", "amount": 5920},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.primaryWightColor,
              shape: BoxShape.circle,
              boxShadow: AppColors.neumorpShadow),
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.6,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChartCustomPainter(
                        width: constraint.maxWidth * 0.4, categories: category),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 16.h,
                  width: constraint.maxWidth * .56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.17),
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 13.h,
                  width: constraint.maxWidth * .56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.35),
                        spreadRadius: 5,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 16.h,
                  width: constraint.maxWidth * .56,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bakiye",
                      style: TextStyle(
                          color: AppColors.headerColor,
                          fontWeight: FontWeight.w600,
                          fontSize: LocalHelper.getFontSize(10)
                      ),),
                      SizedBox(height: 1.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "15.945,00 TL",
                            style: TextStyle(
                                color: AppColors.piechartBalanceColor,
                                fontWeight: FontWeight.w600,
                                fontSize: LocalHelper.getFontSize(13)),
                          ),
                        ],
                      ),
                    ],
                  ),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
