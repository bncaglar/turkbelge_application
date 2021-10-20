import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/first_step_of_registration.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/Straight_line.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/name_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

import '../signin_screen.dart';
import 'components/alreadyHaveAccountRow.dart';

class InitialStepCP extends StatefulWidget {
  @override
  _InitialStepCPState createState() => _InitialStepCPState();
}

class _InitialStepCPState extends State<InitialStepCP> {
  final log = getLogger();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  bool showLoading = false;

  onClickContinue() {
    log.i("onClickContinue started");
    if (_nameKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate() &&
        _newPasswordKey.currentState!.validate()) {
      //todo
      Navigator.pushNamed(
        context,
        FirstStepOfRegistration.routeName,
        arguments: FirstStepOfRegistrationArguments(
            userName: nameController.text,
            userEmail: emailController.text,
            userPassword: passwordController.text),
      );
    } else {
      //todo
    }
  }

  onClickLogIn() {
    log.i("onClickLogIn started");
    Navigator.pushNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: [
            BackgroundALetter(),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildSignInHeader(),
                  buildSignInToAccountText(),
                  buildNameField(),
                  buildEmailField(),
                  buildPasswordField(),
                  buildConfirmPasswordField(),
                  NavigatorButton(
                      showLoading: showLoading,
                      onTap: onClickContinue,
                      textLabel: "Devam"),
                  SizedBox(
                    height: 1.58.h,
                  ),
                  StraightLine(),
                  AlreadyHaveAccountRowCP(
                    topPadding: 1.29.h,
                    onClickLogIn: onClickLogIn,
                    secondText: 'Giriş Yap',
                    firstText: 'Zaten hesabın var mı?',
                    bottomPadding: 0, fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 9.10.h,
      ),
      child: Center(
        child: Text(
          'Hesap Oluştur',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(22),
            color: const Color(0xff686868),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Padding buildSignInToAccountText() {
    return Padding(
      padding: EdgeInsets.only(top: 0.679.h, bottom: 7.20.h),
      child: Center(
        child: Text(
          'Yeni bir hesap oluştur',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: LocalHelper.getFontSize(14),
            color: const Color(0xff707070),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Padding buildNameField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 5.15.h),
      child: Form(
        key: _nameKey,
        child: CustomNameFormNew(
          controller: nameController,
        ),
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 5.29.h),
      child: Form(
        key: _emailKey,
        child: CustomEmailFormNew(
          controller: emailController,
        ),
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 5.36.h),
      child: Form(
        key: _passwordKey,
        child: CustomPasswordFormNew(
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
        child: CustomPasswordFormNew(
          controller: newPasswordController,
          confirmPasswordController: passwordController,
        ),
      ),
    );
  }
}
