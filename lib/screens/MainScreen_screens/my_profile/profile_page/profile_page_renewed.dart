import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class ProfilePageRenewed extends StatefulWidget {
  @override
  _ProfilePageRenewedState createState() => _ProfilePageRenewedState();
}

class _ProfilePageRenewedState extends State<ProfilePageRenewed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildProfileBody(),
      ),
    );
  }

  Padding buildProfileBody() {
    return Padding(
      padding: EdgeInsets.only(
        right: 2.65.w,
        left: 2.65.w,
        top: 1.49.h,
      ),
      child: Stack(
        children: [
          buildProfilePagePNG(),
          buildHeaderColumn(),
        ],
      ),
    );
  }

  Container buildProfilePagePNG() {
    return Container(
      width: 94.w,
      height: 33.42.h,
      child: Image.asset(
        "assets/red_background.png",
        fit: BoxFit.fill,
      ),
    );
  }

  Column buildHeaderColumn(){
    return Column(
      children: [
        buildUserHeader(),
        buildCompanyName(),
        SizedBox(height: 0.67.h,),
        buildUserText(),
        SizedBox(height: 0.67.h,),
        buildDataTableContainer(),
      ],
    );
  }

  Padding buildUserHeader(){
    return Padding(
      padding: EdgeInsets.only(
        top: 2.30.h,
        bottom: 0.95.h,
      ),
      child: Center(
        child: SvgPicture.asset(
          "svg/user_header.svg"
        ),
      ),
    );
  }

  Text buildCompanyName(){
    return Text(
      "İleka Akademi A.S.",
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: LocalHelper.getFontSize(13),
          color: AppColors.primaryWightColor,
      ),
    );
  }

  Text buildUserText(){
    return Text(
        "Kullanıcı",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: LocalHelper.getFontSize(10),
          color: AppColors.profileUserTextColor,
        ),
    );
  }

  Container buildDataTableContainer(){
    return Container(
      width: 88.88.w,
      height: 14.94.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.profileTableBorderColor,),
        borderRadius: BorderRadius.all(Radius.circular(5),
        ),
      ),
    );
  }

  

}
