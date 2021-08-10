import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class RegistrationPageHeader extends StatefulWidget {
  final bool? addBackButton;
  final String? headerText;
  final String? subText;

  RegistrationPageHeader(
      {required this.headerText,
      required this.subText,
      required this.addBackButton});

  @override
  _RegistrationPageHeaderState createState() => _RegistrationPageHeaderState();
}

class _RegistrationPageHeaderState extends State<RegistrationPageHeader> {
  final log = getLogger();

  onClickBackBtn() {
    log.i("onClickBackBtn started");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return buildHeader();
  }

  Container buildHeader() {
    return Container(
      width: double.infinity,
      height: 22.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildRegistrationPageHeaderRow(),
          buildCreateAccount(),
        ],
      ),
    );
  }

  Row buildRegistrationPageHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.addBackButton! ? buildBackBtn() : Container(),
        widget.addBackButton! ? Container() : contactUsIcon()
      ],
    );
  }

  Padding contactUsIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, top: 1.h),
      child: IconButton(
        onPressed: () {
          LocalHelper.showTheBottomSheet(
            context: context,
            child: _buildBottomNavigationMenu(),
          );
        },
        icon: Icon(
          Icons.contact_support_outlined,
          size: 25.sp,
        ),
      ),
    );
  }

  Row _buildBottomNavigationMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        callUs(),
        emailUs(),
      ],
    );
  }

  Padding callUs() {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 5.w),
      child: Container(
        height: 15.h,
        width: 40.w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bizi arayın",
                style: TextStyle(
                  fontSize: LocalHelper.getFontSize(15),
                  color: AppColors.primaryWightColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              IconButton(
                onPressed: () {
                  _callNumber();
                },
                icon: Icon(
                  Icons.phone_outlined,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding emailUs() {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, right: 5.w),
      child: Container(
        height: 15.h,
        width: 40.w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bize ulaşın",
                style: TextStyle(
                  fontSize: LocalHelper.getFontSize(15),
                  color: AppColors.primaryWightColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              IconButton(
                onPressed: () {
                  _sendEmail();
                },
                icon: Icon(
                  Icons.mail_outline,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align buildBackBtn() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 1.w, top: 1.h),
        child: IconButton(
          onPressed: () {
            onClickBackBtn();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.newColor4Background,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Column buildCreateAccount() {
    return Column(
      children: [
        createAccountText(),
        SizedBox(
          height: 1.5.h,
        ),
        createNewAccountText(),
      ],
    );
  }

  Container createAccountText() {
    return Container(
      width: double.infinity,
      height: 5.h,
      child: Center(
        child: Text(
          widget.headerText!,
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(25),
            color: AppColors.backgroundPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Container createNewAccountText() {
    return Container(
      width: double.infinity,
      height: 3.h,
      child: Center(
        child: Text(
          widget.subText!,
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(12),
            color: AppColors.backgroundPrimaryColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  _callNumber() async {
    const number = '+905448010899'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendEmail() async {
    final snackBar = SnackBar(
      content: Text('Bir hata oluştu!'),
      action: SnackBarAction(
        label: 'Tekrar dene',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      backgroundColor: Colors.red,
    );
    try {
      final Email email = Email(
        body: 'Türkbelge Destek Ekibi',
        subject: 'Yardım ve Destek',
        recipients: ['hv.plt.caglar@gmail.com'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
