import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ThrowErrorContainer extends StatefulWidget {
  @override
  _ThrowErrorContainerState createState() => _ThrowErrorContainerState();
}

class _ThrowErrorContainerState extends State<ThrowErrorContainer> {
  @override
  Widget build(BuildContext context) {
    return throwErrorWidget();
  }
  Widget throwErrorWidget(){
    return Center(
      child: InkWell(
        onTap: (){
          setState(() {

          });
        },
        child: Container(
          color: Colors.white,
          height: 15.h,
          width: 50.w,
          child: Center(
            child: Column(
              children: [
                Text("Bir hata oluştu!",
                  style: TextStyle(
                      color: AppColors.textFormUnderLineColor,
                      fontSize: LocalHelper.getFontSize(14),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'
                  ),
                ),
                SizedBox(height: 1.7.h,),
                Container(
                  height: 4.5.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFormUnderLineColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text("Tekrar dene"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
