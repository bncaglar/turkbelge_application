import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePageHeader extends StatefulWidget {
  final String customerNumber;
  final String email;

  ProfilePageHeader({required this.email, required this.customerNumber});

  @override
  _ProfilePageHeaderState createState() => _ProfilePageHeaderState();
}

class _ProfilePageHeaderState extends State<ProfilePageHeader> {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  XFile? image;
  String? imageUrl = "";
  final log = Logger();

   Future<List> checkProfilePhoto() async {
    List list = [];
   try{
     var snapshot = await _storage
         .ref()
         .child("ProfilePhoto/" + widget.customerNumber + "/" + widget.email).getDownloadURL();
     list.addAll([{
       "state": "true",
       "snap": snapshot
     }]);
     return list;
   }catch(e){
     log.i(e.toString());
     list.addAll([{
       "state": "false",
       "snap": "svg/user_header.svg"
     }]);
     return list;
   }
  }

  Future getProfilePhoto() async{
     try{
       var snapshot = await _storage
           .ref()
           .child("ProfilePhoto/" + widget.customerNumber + "/" + widget.email).getDownloadURL();
       return snapshot;
     }catch(e){
       return "svg/user_header.svg";
     }
  }

  uploadImage() async {
    log.i("upload Image clicked");
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      ///todo is photo uploaded true
      var file = File(image!.path);
      if (image != null) {
        var snapshot = await _storage
            .ref()
            .child("ProfilePhoto/" + widget.customerNumber + "/" + widget.email)
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        log.w(downloadUrl);
        setState(() {
          imageUrl = downloadUrl;
        });
      }
    }
  }

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
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Image.asset(
        "assets/red_background.png",
        fit: BoxFit.fill,
      ),
    );
  }

  Padding buildHeaderColumn() {
    return Padding(
      padding: EdgeInsets.only(right: 2.77.w, left: 2.77.w),
      child: Column(
        children: [
          buildUserHeader(),
          buildCompanyName(),
          SizedBox(
            height: 0.67.h,
          ),
          buildUserText(),
          SizedBox(
            height: 0.67.h,
          ),
          buildDataTableContainer(),
        ],
      ),
    );
  }

  Padding buildUserHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.30.h,
        bottom: 0.95.h,
      ),
      child: InkWell(
        onTap: uploadImage,
        child: FutureBuilder<List>(
          future: checkProfilePhoto(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:{
                return Container(
                  width: 14.49.w,
                  height: 8.15.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryWightColor,
                    ),
                  ),
                );
              }
              case ConnectionState.active:{
                return Container(
                  width: 14.49.w,
                  height: 8.15.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryWightColor,
                    ),
                  ),
                );
              }
              case ConnectionState.done:{
                return Container(
                    width: 14.49.w,
                    height: 8.15.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent
                    ),
                    child: snapshot.data![0]["state"] == "true" ? CircleAvatar(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.white70,
                      backgroundImage: NetworkImage(snapshot.data![0]["snap"]!,),
                    ) : SvgPicture.asset("svg/user_header.svg",)
                );
              }
              default:{
                if(snapshot.hasData){
                  return Container(
                      width: 14.49.w,
                      height: 8.15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent
                      ),
                      child: snapshot.data![0]["state"] == "true" ? CircleAvatar(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(snapshot.data![0]["snap"]!,),
                      ) : SvgPicture.asset("svg/user_header.svg",)
                  );
                }else{
                  return SvgPicture.asset("svg/user_header.svg");
                }
              }
            }
          },
        ),
      ),
    );
  }

  Text buildCompanyName() {
    return Text(
      "İleka Akademi A.S.",
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: LocalHelper.getFontSize(13),
        color: AppColors.primaryWightColor,
      ),
    );
  }

  Text buildUserText() {
    return Text(
      "Kullanıcı",
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: LocalHelper.getFontSize(10),
        color: AppColors.profileUserTextColor,
      ),
    );
  }

  Container buildDataTableContainer() {
    return Container(
      width: 88.88.w,
      height: 14.94.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.profileTableBorderColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: buildDataColum(),
    );
  }

  Column buildDataColum() {
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

  Row buildCustomerNo() {
    return Row(
      children: [
        Container(
          height: 4.95.h,
          width: 24.w,
          padding: EdgeInsets.only(left: 2.17.w),
          child: Center(
            child: Text(
              "Müşteri No",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildCustomerNumberValue(),
      ],
    );
  }

  Row buildEmail() {
    return Row(
      children: [
        Container(
          height: 4.95.h,
          width: 24.w,
          padding: EdgeInsets.only(left: 2.17.w),
          child: Center(
            child: Text(
              "E-Posta",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildEmailValue(),
      ],
    );
  }

  Row buildPackage() {
    return Row(
      children: [
        Container(
          height: 4.45.h,
          width: 24.w,
          padding: EdgeInsets.only(left: 2.17.w),
          child: Center(
            child: Text(
              "Paket",
              style: TextStyle(
                  fontSize: LocalHelper.getFontSize(13),
                  fontFamily: 'Poppins',
                  color: AppColors.primaryWightColor),
            ),
          ),
        ),
        buildHorizontalStraightLine(),
        buildPackageValue(),
      ],
    );
  }

  Container buildCustomerNumberValue() {
    return Container(
      height: 4.95.h,
      padding: EdgeInsets.only(left: 2.17.w),
      child: Center(
        child: Text(
            widget.customerNumber,
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor),
        ),
      ),
    );
  }

  Container buildEmailValue() {
    return Container(
      height: 4.45.h,
      padding: EdgeInsets.only(left: 2.17.w),
      child: Center(
        child: Text(
          widget.email,
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor),
        ),
      ),
    );
  }

  Container buildPackageValue() {
    return Container(
      height: 4.45.h,
      padding: EdgeInsets.only(left: 2.17.w),
      child: Center(
        child: Text(
          "Gümüş Paket",
          style: TextStyle(
              fontSize: LocalHelper.getFontSize(13),
              fontFamily: 'Poppins',
              color: AppColors.primaryWightColor),
        ),
      ),
    );
  }

  Container buildHorizontalStraightLine() {
    return Container(
      height: 4.45.h,
      width: 1,
      color: AppColors.profileTableBorderColor,
    );
  }

  Container buildVectoralStraightLine() {
    return Container(
      width: 88.88.w,
      height: 1,
      color: AppColors.profileTableBorderColor,
    );
  }
}
