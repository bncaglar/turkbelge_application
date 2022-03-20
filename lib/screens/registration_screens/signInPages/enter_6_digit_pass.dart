import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/6digit_password_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/customer_number_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

import 'SignInScreen_renewed.dart';
class EnterSixDigitPassword extends StatefulWidget {
  static const routeName = '/EnterSixDigitPassword';
  String? customerNumber;
  String? email;
  String? password;
  EnterSixDigitPassword({
    required this.password,
    required this.email,
    required this.customerNumber
});
  @override
  _EnterSixDigitPasswordState createState() => _EnterSixDigitPasswordState();
}

class _EnterSixDigitPasswordState extends State<EnterSixDigitPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool showLoading = false;

  onClickContinue() async{
    var sp = await SharedPreferences.getInstance();

    setState(() {
      showLoading = true;
    });
    if(_passwordKey.currentState!.validate() &&
        _newPasswordKey.currentState!.validate()){
      sp.setString("customerNumber", widget.customerNumber!);
      sp.setString("email", widget.email!);
      sp.setString("password", widget.password!);
      sp.setString("primaryPassword", passwordController.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPageRenewed(),
        ),
      );

    }else{
      setState(() {
        showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: [
            BackgroundALetter(),
            buildEnterNewPasswordBody(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildEnterNewPasswordBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            buildBody()
          ],
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildSignInHeader(),
        buildSignInToAccountText(),
        buildPasswordField(),
        buildConfirmPasswordField(),
        buildNavigatorBtn(),
        buildDesc()
      ],
    );
  }

  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 9.10.h,
      ),
      child: Center(
        child: Text(
          'Beni Hatırla',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(22),
            color: AppColors.headerColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Padding buildSignInToAccountText() {
    return Padding(
      padding: EdgeInsets.only(top: 0.679.h, bottom: 6.80.h),
      child: Center(
        child: Text(
          '6 haneli bir şifre belirleyin.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(14),
            color: AppColors.headerBelowColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 4.h),
      child: Form(
        key: _passwordKey,
        child: SixDigitNumberForm(
          isObscure: true,
          confirmController: passwordController,
          hintText: "Şifre",
          controller: passwordController,
        ),
      ),
    );
  }

  Padding buildConfirmPasswordField() {
    return Padding(
      padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 3.80.h),
      child: Form(
        key: _newPasswordKey,
        child: SixDigitNumberForm(
          isObscure: true,
          confirmController: passwordController,
          hintText: "Şifre Tekrar",
          controller: newPasswordController,
        ),
      ),
    );
  }

  Padding buildNavigatorBtn() {
    return Padding(
        padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 2.44.h),
        child: NavigatorButton(
          onTap: onClickContinue,
          showLoading: showLoading,
          textLabel: "Devam",
        ));
  }

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w,
        left: 6.w,
      ),
      child: Text(
        "Girişini kolaylaştırmak için belirlediğin 6 haneli şifreyi kullanarak kolayca giriş yapabilirsin.",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          color: AppColors.infoContentDialogColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

}
class EnterSixDigitPassArguments {
  String? customerNumber;
  String? email;
  String? password;

  EnterSixDigitPassArguments({
    this.customerNumber,
    this.email,
    this.password
  });
}