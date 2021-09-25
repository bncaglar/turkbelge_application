import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfilePageCompanyInfo extends StatefulWidget {
  @override
  _ProfilePageCompanyInfoState createState() => _ProfilePageCompanyInfoState();
}

class _ProfilePageCompanyInfoState extends State<ProfilePageCompanyInfo> {
  @override
  Widget build(BuildContext context) {
    return buildCompanyInfo();
  }

  Container buildCompanyInfo() {
    return Container(
      height: 25.h,
      width: 90.w,
      child: Row(
        children: [
          buildDataTableLeft(),
          buildDataTableRight(),
        ],
      ),
    );
  }

  Flexible buildDataTableLeft() {
    return Flexible(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEachTableLeft("Müşteri No: ",15, 0),
          buildEachTableLeft("E-Posta: ",0, 0),
          buildEachTableLeft("Şirket: ",0, 15)
        ],
      ),
    );
  }

  Container buildEachTableLeft(String textInput, double radiusTop, double radiusBottom) {
    return Container(
      height: 8.h,
      width: 36.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radiusTop),
            bottomLeft: Radius.circular(radiusBottom)),
      ),
      child: Center(
        child: Text(textInput),
      ),
    );
  }

  Flexible buildDataTableRight() {
    return Flexible(
      flex: 3,
      child: Column(
        children: [
          buildEachTableRight("653214",15, 0),
          buildEachTableRight("ekstreadmin@ilekaekstre.com.tr",0, 0),
          buildEachTableRight("İleka Akademi A.Ş. ",0, 15),
        ],
      ),
    );
  }

  Container buildEachTableRight(String textOutput, double radiusTop, double radiusBottom) {
    return Container(
      height: 8.h,
      width: 54.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(radiusTop),
            bottomRight: Radius.circular(radiusBottom)),
      ),
      child: Center(
        child: Text(textOutput),
      ),
    );
  }
}
