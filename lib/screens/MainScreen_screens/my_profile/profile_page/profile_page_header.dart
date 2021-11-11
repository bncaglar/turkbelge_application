import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return buildProfileBody();
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
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
      child: buildDataColum(),
    );
  }

  Column buildDataColum(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildCustomerNo(),
        buildVectoralStraightLine(),
        buildEmail(),
        buildVectoralStraightLine(),
        buildPackage(),
      ],
    );
  }

  Row buildCustomerNo(){
    return Row(
      children: [
        Container(
          height: 4.95.h,
          width: 24.w,
          padding: EdgeInsets.only(
              left: 2.17.w
          ),
          child: Center(
            child: Text(
              "Müşteri No",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor
              ),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildCustomerNumberValue(),
      ],
    );
  }

  Row buildEmail(){
    return Row(
      children: [
        Container(
          height: 4.95.h,
          width: 24.w,
          padding: EdgeInsets.only(
              left: 2.17.w
          ),
          child: Center(
            child: Text(
              "E-Posta",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor
              ),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildEmailValue(),
      ],
    );
  }

  Row buildPackage(){
    return Row(
      children: [
        Container(
          height: 4.45.h,
          width: 24.w,
          padding: EdgeInsets.only(
              left: 2.17.w
          ),
          child: Center(
            child: Text(
              "Paket",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor
              ),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildPackageValue(),
      ],
    );
  }

  Container buildCustomerNumberValue(){
    return Container(
      height: 4.95.h,
      padding: EdgeInsets.only(
          left: 2.17.w
      ),
      child: Center(
        child: Text(
          "653214",
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor
          ),
        ),
      ),
    );
  }

  Container buildEmailValue(){
    return Container(
      height: 4.45.h,
      padding: EdgeInsets.only(
          left: 2.17.w
      ),
      child: Center(
        child: Text(
          "ekstre@ilekaekstre.com.tr",
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor
          ),
        ),
      ),
    );
  }

  Container buildPackageValue(){
    return Container(
      height: 4.45.h,
      padding: EdgeInsets.only(
          left: 2.17.w
      ),
      child: Center(
        child: Text(
          "Gümüş Paket",
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor
          ),
        ),
      ),
    );
  }

  Container buildHorizontalStraightLine(){
    return Container(
      height: 4.45.h,
      width: 1,
      color: AppColors.profileTableBorderColor,
    );
  }

  Container buildVectoralStraightLine(){
    return Container(
      width: 88.88.w,
      height: 1,
      color: AppColors.profileTableBorderColor,
    );
  }
}
