import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class AddUserHeaderPart extends StatefulWidget {
  @override
  _AddUserHeaderPartState createState() => _AddUserHeaderPartState();
}

class _AddUserHeaderPartState extends State<AddUserHeaderPart> {
  onClickBackBtn(){
    Get.back();
  }
  @override
  Widget build(BuildContext context) {
    return buildHeader();
  }

  Padding buildHeader(){
    return Padding(
      padding: EdgeInsets.only(
        bottom: 9.51.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackBtn(AppColors.textFormUnderLineColor),
          buildAddUserText(),
          buildBackBtn(AppColors.primaryWightColor),
        ],
      ),
    );
  }

  Padding buildBackBtn(Color color){
    return Padding(
      padding: EdgeInsets.only(
        top: 3.39.h,
      ),
      child: InkWell(
        onTap: onClickBackBtn,
        child: SvgPicture.asset("svg/backBtn.svg",color: color
          ,),
      ),
    );
  }

  Padding buildAddUserText(){
    return Padding(
      padding: EdgeInsets.only(
        top: 2.98.h,
      ),
      child: Center(
        child: Text(
          "Kullanıcı Ekle",
          style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.headerColor,
              fontSize: LocalHelper.getFontSize(15),
              fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }

}
