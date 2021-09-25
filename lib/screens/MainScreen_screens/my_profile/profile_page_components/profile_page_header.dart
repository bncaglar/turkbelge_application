import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ProfilePageHeader extends StatefulWidget {
  @override
  _ProfilePageHeaderState createState() => _ProfilePageHeaderState();
}

class _ProfilePageHeaderState extends State<ProfilePageHeader> {
  @override
  Widget build(BuildContext context) {
    return buildHeader();
  }

  Padding buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      child: Container(
        height: 20.h,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPlaceHolder(),
                buildUserText(),
                buildSettings(),
              ],
            ),
            buildCircleAvatar(),
            buildCompanyName(),
          ],
        ),
      ),
    );
  }

  Text buildUserText() {
    return Text(
      "KULLANICI",
      style: TextStyle(
        color: AppColors.primaryWightColor,
        fontSize: LocalHelper.getFontSize(15),
      ),
    );
  }

  Container buildPlaceHolder(){
    return Container(
      width: 13.w,
    );
  }
  Container buildSettings(){
    return Container(
      width: 13.w,
      child: IconButton(
        icon: Icon(Icons.settings,color: Colors.white, size: LocalHelper.getFontSize(20),),
        onPressed: (){
          print("Settings Pressed...");
        },
      ),
    );
  }
  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
    radius: 25,
      backgroundColor: AppColors.primaryWightColor,
    );
  }

  Text buildCompanyName() {
    return Text(
      "İLEKA AKADEMİ A.S.",
      style: TextStyle(
        color: AppColors.primaryWightColor,
        fontSize: LocalHelper.getFontSize(15),
      ),
    );
  }
}
