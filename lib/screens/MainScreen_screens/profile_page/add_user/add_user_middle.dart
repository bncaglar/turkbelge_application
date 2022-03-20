import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';

class AddUserPageMiddlePart extends StatefulWidget {
  @override
  _AddUserPageMiddlePartState createState() => _AddUserPageMiddlePartState();
}

class _AddUserPageMiddlePartState extends State<AddUserPageMiddlePart> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return buildMiddleColumn();
  }

  Column buildMiddleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEmailField(),
        buildUnderLineText(),
        SizedBox(height: 7.h),
        buildBanksText(),
        buildBankDescText(),
      ],
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 1.49.h,
      ),
      child: CustomEmailFormNew(
        controller: emailController,
      ),
    );
  }

  Text buildUnderLineText() {
    return Text(
      "Yeni bir kullanıcı eklemek eklemek için e-posta adresini giriniz.",
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          fontWeight: FontWeight.w500,
          color: AppColors.infoContentDialogColor),
      textAlign: TextAlign.center,
    );
  }

  Text buildBanksText() {
    return Text(
      "Bankalar",
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(17),
          fontWeight: FontWeight.w600,
          color: AppColors.filterAgainTextColor),
    );
  }

  Padding buildBankDescText() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 1.90.h,
        top: 1.h,
      ),
      child: Text(
        "Yetki vermek istediğiniz bankları aşağıdan seçiniz.",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(11),
            color: AppColors.infoContentDialogColor),
      ),
    );
  }
}
