import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/already_have_account_text.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/form/customer_number_form.dart';
import 'package:turkbelge_application/widgets/form/email_form.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/password_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';
import '../noInternetConnectionPage.dart';
import 'creating_profile/initial_step_of_registration.dart';
import 'forget_screens/forget_customer_number/forget_customer_number.dart';
import 'forget_screens/forget_password/forget_password_screen.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/SignInPage';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final failedToSignIn = SnackBar(
    content: Text('Bilgilerinizi kontrol edip tekrar deneyiniz!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {},
    ),
    backgroundColor: Colors.red,
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _customerNumberKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool showLoading = false;
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  onClickForgetCustomerNumber() {
    log.i("onClickForgetCustomerNumber started");
    Navigator.pushNamed(context, ForgetCustomerNumberPage.routeName);
  }

  onClickForgetPassword() {
    log.i("onClickForgetPassword started");
    Navigator.pushNamed(context, ForgetPasswordPage.routeName);
  }

  onClickSignUp() {
    Navigator.pushNamed(context, InitialStepOfRegistration.routeName);
  }

  onClickContinue() async {
    log.i("onClickContinue started");
    if (_customerNumberKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      try {
        String verifyEmailForAuth = await FireStoreService()
            .verifyEmailAddressWithCustomerNumber(
                customerNumberController.text.trim());
        if (verifyEmailForAuth == emailController.text.trim()) {

          await AuthenticationService(_firebaseAuth).signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          User? user = _firebaseAuth.currentUser;
          if (user != null) {
            print("*******");
            ///we dont register the subusers into the firebase auth system so if the user is null its either the user credentials
            ///are wrong or the user is subuser.

            await FireStoreService()
                .saveUserLogInActivity(customerNumberController.text);

            ///we save the logIn Activity to the firestore.
            // String platformVersion = await GetMac.macAddress;
            //
            // print("platform version: ${platformVersion}");
            // await FireStoreService().addMacAddress(
            //     customerNumberController.text, platformVersion);
            setState(() {
              showLoading = false;
            });
            Navigator.pushReplacementNamed(context, FirstNavigation.routeName,
                arguments: FirstNavigationArguments(
                  subUserEmail: "null",
                    isUserAdmin: true,
                    customerNumber: customerNumberController.text.trim()));

            ///navigate user to the FirstNavigationPage

          } else {
            await FireStoreService()
                .saveUserFaultyInput(customerNumberController.text.trim());
            setState(() {
              showLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);

            ///password is wrong for admin
          }
        } else {
          try {
            bool? checkCn = await FireStoreService()

                ///check subuser's customer number here
                .checkIfSubUsersEmailExist(customerNumberController.text.trim(),
                    emailController.text.trim());
            if (checkCn == true) {
              ///get subuser's email here
              String getUserEmail = await FireStoreService().getSubUsersEmail(
                  customerNumberController.text.trim(),
                  emailController.text.trim());
              if (getUserEmail == emailController.text.trim()) {
                ///get subUser's password here
                String getUserPassword = await FireStoreService()
                    .checkUserPassword(passwordController.text.trim(),
                        emailController.text.trim());
                if (getUserPassword == passwordController.text.trim()) {
                  ///check if the email and password valid for subUser
                  await FireStoreService().saveUserLogInActivity(
                      customerNumberController.text.trim());
                  setState(() {
                    showLoading = false;
                  });
                  Navigator.pushReplacementNamed(
                      context, FirstNavigation.routeName,
                      arguments: FirstNavigationArguments(
                        subUserEmail: emailController.text.trim(),
                          isUserAdmin: false,
                          customerNumber:
                              customerNumberController.text.trim()));

                  ///we ll log the sub user in

                } else {
                  await FireStoreService().saveUserFaultyInput(
                      customerNumberController.text.trim());

                  ///todo sign in failed
                  ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
                  setState(() {
                    showLoading = false;
                  });
                }
              } else {
                ///todo sign in failed
                setState(() {
                  showLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
              }
            } else {
              ///todo sign in failed
              setState(() {
                showLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
            }
          } on FirebaseAuthException {
            setState(() {
              showLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
          }
        }
      } on FirebaseAuthException {
        setState(() {
          showLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: <Widget>[

          ],
        )
      ),
    );
  }

  SingleChildScrollView buildBodyColumn() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegistrationPageHeader(
            addBackButton: false,
            subText: AppLocalizations.of(context).loginToYourAccount,
            headerText: AppLocalizations.of(context).logIn,
          ),
          buildSignInBody(),
          AlreadyHaveAnAccountText(
              onClickHighlightedText: onClickSignUp,
              highlightedText: AppLocalizations.of(context).signUp,
              normalText: AppLocalizations.of(context).doNotHaveAnAccount),
        ],
      ),
    );
  }

  InkWell buildForgetCustomerNumberField() {
    return InkWell(
      onTap: () {
        onClickForgetCustomerNumber();
      },
      child: Text(
        AppLocalizations.of(context).forgotMyCustomerNumber,
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.backgroundPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  InkWell buildForgetPasswordField() {
    return InkWell(
      onTap: () {
        onClickForgetPassword();
      },
      child: Text(
        AppLocalizations.of(context).forgotMyPassword,
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.backgroundPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Container buildSignInBody() {
    return Container(
      height: 65.h,
      width: double.infinity,
      child: Column(
        children: [
          buildCustomerNumberField(),
          buildEmailField(),
          buildPasswordField(),
          SizedBox(
            height: 4.h,
          ),
          buildLogInButton(),
          buildForgetInfoRow(),
        ],
      ),
    );
  }

  Padding buildCustomerNumberField() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _customerNumberKey,
          child: CustomerNumberForm(
            controller: customerNumberController,
            labelText: AppLocalizations.of(context).customerNumber,
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

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
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

  NavigationButton buildLogInButton() {
    return NavigationButton(
      addBoxShape: false,
      navigationButtonText: AppLocalizations.of(context).logIn,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinue,
      margin: EdgeInsets.only(
        left: 4.69.w,
        right: 4.69.w,
      ),
    );
  }

  Padding buildForgetInfoRow() {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 5.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildForgetCustomerNumberField(),
            buildForgetPasswordField(),
          ],
        ),
      ),
    );
  }

  // Container rememberMeBox() {
  //   ///todo remember me box will be used to keep user logged in, in accordance with the preference of the user
  //   return Container(
  //     height: 8.h,
  //     width: double.infinity,
  //     child: CheckboxListTile(
  //       activeColor: AppColors.newColor4Background,
  //       title: Text(
  //         "Hesabımı açık tut",
  //         style: TextStyle(
  //           fontSize: LocalHelper.getFontSize(13),
  //           color: AppColors.backgroundPrimaryColor,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       value: sozlesmeDurumu,
  //       controlAffinity: ListTileControlAffinity.leading,
  //       onChanged: (bool? data) async {
  //         final prefs = await SharedPreferences.getInstance();
  //         bool myBool = prefs.getBool('state') ?? false;
  //         setState(() {
  //           sozlesmeDurumu = data!;
  //           myBool = sozlesmeDurumu;
  //           prefs.setBool('state', myBool);
  //           print(myBool);
  //         });
  //       },
  //     ),
  //   );
  // }

  Future<bool?> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
