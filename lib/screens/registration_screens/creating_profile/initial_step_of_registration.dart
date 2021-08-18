import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/first_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/already_have_account_text.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/form/email_form.dart';
import 'package:turkbelge_application/widgets/form/name_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/widgets/form/password_again.dart';
import 'package:turkbelge_application/widgets/form/password_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

import '../signin_screen.dart';

class InitialStepOfRegistration extends StatefulWidget {
  static const routeName = '/InitialStepOfRegistration';

  @override
  _InitialStepOfRegistrationState createState() =>
      _InitialStepOfRegistrationState();
}

class _InitialStepOfRegistrationState extends State<InitialStepOfRegistration> {
  final log = getLogger();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();

  final _emailKey = GlobalKey<FormState>();

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
        body: SingleChildScrollView(
          child: Container(
            height: 95.h,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegistrationPageHeader(
                  addBackButton: true,
                  subText: AppLocalizations.of(context).createANewAccount,
                  headerText: AppLocalizations.of(context).createAccount,
                ),
                buildBody(),
                AlreadyHaveAnAccountText(
                  onClickHighlightedText: () {
                    onClickLogIn();
                  },
                  highlightedText: AppLocalizations.of(context).logIn,
                  normalText: AppLocalizations.of(context).alreadyHaveAnAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildNameField(),
        buildEmailField(),
        buildPasswordField(),
        buildNewPasswordField(),
        buildContinueNtb(),
      ],
    );
  }

  NavigationButton buildContinueNtb() {
    return NavigationButton(
      addBoxShape: false,
      backgroundColor: AppColors.newColor4Background,
      navigationButtonText: AppLocalizations.of(context).continueText,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinue,
      margin: EdgeInsets.only(
        left: 4.69.w,
        right: 4.69.w,
        top: 2.754.h,
      ),
    );
  }

  Padding buildNewPasswordField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Form(
          key: _newPasswordKey,
          child: EnterPasswordAgain(
            confirmPasswordController: passwordController,
            labelText: AppLocalizations.of(context).passwordAgain,
            controller: newPasswordController,
          ),
        ),
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Form(
          key: _passwordKey,
          child: PasswordForm(
            labelText: AppLocalizations.of(context).passwordLabelText,
            controller: passwordController,
          ),
        ),
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Form(
          key: _emailKey,
          child: EmailForm(
            labelText: AppLocalizations.of(context).emailLabelText,
            controller: emailController,
          ),
        ),
      ),
    );
  }

  Padding buildNameField() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _nameKey,
          child: NameForm(
            labelText: AppLocalizations.of(context).nameSurname,
            controller: nameController,
          ),
        ),
      ),
    );
  }
}
