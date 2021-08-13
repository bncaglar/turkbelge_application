import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_phone_auth.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/email_form.dart';
import 'package:turkbelge_application/widgets/form/password_form.dart';
import 'package:turkbelge_application/widgets/form/tckn_or_vkn_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

class ForgetCustomerNumberPage extends StatefulWidget {
  static const routeName = '/ForgetCustomerNumberPage';

  @override
  _ForgetCustomerNumberPageState createState() =>
      _ForgetCustomerNumberPageState();
}

class _ForgetCustomerNumberPageState extends State<ForgetCustomerNumberPage> {
  final log = getLogger();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tcknOrVknController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _tcknOrCknKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  final failedToSignIn = SnackBar(
    content: Text('Bilgilerinizi kontrol edip tekrar deneyiniz!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );

  onClickContinue() async {
    log.i("onClickContinue started");
    if (_tcknOrCknKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&

        ///CHECK IF ALL THE VALIDATORS ARE NOT THROWING ERROR
        _passwordKey.currentState!.validate()) {
      try {
        setState(() {
          showLoading = true;
        });
        await AuthenticationService(_auth).signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        User? user = _auth.currentUser;
        print(tcknOrVknController.text);
        if (tcknOrVknController.text.length == 11) {
          ///check if the input is tckn or vkn
          String verifyTckn = await FireStoreService().verifyTCKN(user!.uid);
          if (verifyTckn == tcknOrVknController.text) {
            ///check if the tckn is valid
            ///todo navigate user to the next step
            Navigator.pushNamed(
                context, ForgetCustomerNumberPhoneAuth.routeName,
                arguments: ForgetCustomerNumberPhoneAuthArguments(
                  tcknOrVknNumber: tcknOrVknController.text,
                  userEmail: emailController.text,
                  userPassword: passwordController.text,
                ));
            setState(() {
              showLoading = false;
            });
          } else {
            ///TCKN IS NOT VALID!!
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
            setState(() {
              showLoading = false;
            });
          }
        } else {
          ///input is VKN
          ///check for the vkn number
          String verifyVKN = await FireStoreService().verifyVKN(user!.uid);
          if (verifyVKN == tcknOrVknController.text) {
            ///todo navigate user to the next steP
          } else {
            ///VKN IS NOT VALID!!
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
            setState(() {
              showLoading = false;
            });
          }
        }
      } on FirebaseException {
        ///todo throw error
        ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
        setState(() {
          showLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildForgetCustomerPageBody(),
      ),
    );
  }

  SingleChildScrollView buildForgetCustomerPageBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegistrationPageHeader(
            addBackButton: true,
            subText: AppLocalizations.of(context).resetYourCustomerNumber,
            headerText: AppLocalizations.of(context).forgotMyCustomerNumber,
          ),
          buildTcknOrVkn(),
          buildEmailField(),
          buildPasswordField(),
          buildResendButton(),
          enterYourCredentialsText()
        ],
      ),
    );
  }

  Padding buildTcknOrVkn() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _tcknOrCknKey,
          child: TcknOrVknForm(
            controller: tcknOrVknController,
            labelText: AppLocalizations.of(context).tcknOrVkn,
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
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
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

  NavigationButton buildResendButton() {
    return NavigationButton(
      navigationButtonText: AppLocalizations.of(context).send,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinue,
      margin: EdgeInsets.only(
        left: 4.69.w,
        right: 4.69.w,
        top: 4.754.h,
      ),
    );
  }

  Padding enterYourCredentialsText() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 9.h,
        child: Center(
          child: Text(
            AppLocalizations.of(context).forgetCustomerNumberInfoText,
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
