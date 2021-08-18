import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/widgets/form/password_again.dart';
import 'package:turkbelge_application/widgets/form/password_form.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

class EnterNewPasswordScreen extends StatefulWidget {
  static const routeName = '/EnterNewPasswordScreen';

  @override
  _EnterNewPasswordScreenState createState() => _EnterNewPasswordScreenState();
}

class _EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final log = getLogger();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final passwordchanged = SnackBar(
    content: Text('Şifre değiştirildi!'),
    action: SnackBarAction(
      label: 'Tamam',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.green,
  );

  onClickContinue() async {
    log.i("onClickContinue started");
    User? user = _firebaseAuth.currentUser;
    if (_passwordKey.currentState!.validate() &&
        _newPasswordKey.currentState!.validate()) {
      if (user != null) {
        await user.updatePassword(newPasswordController.text);
        await _firebaseAuth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(passwordchanged);
        Navigator.pushReplacementNamed(context, SignInPage.routeName);
      } else {
        //throw error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildEnterNewPasswordBody(),
      ),
    );
  }

  SingleChildScrollView buildEnterNewPasswordBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegistrationPageHeader(
              addBackButton: true,
              subText: AppLocalizations.of(context).resetPassword,
              headerText: AppLocalizations.of(context).forgotMyPassword,
            ),
            buildBody()
          ],
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildPasswordField(),
        buildNewPasswordField(),
        buildContinueNtb(),
        enterCodeText()
      ],
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
      padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
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

  Padding enterCodeText() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 5.h,
        child: Center(
          child: Text(
            "Şifreni iki kez girerek sıfırlayabilirsin",
            style: TextStyle(
              fontSize: LocalHelper.getFontSize(12),
              color: AppColors.backgroundPrimaryColor,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
