import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/Straight_line.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/customer_number_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'create_profile_screens/components/alreadyHaveAccountRow.dart';
import 'creating_profile/initial_step_of_registration.dart';
import 'forget_screens/forget_customer_number/forget_customer_number.dart';
import 'forget_screens/forget_password/forget_password_screen.dart';

class SignInPageRenewed extends StatefulWidget {
  @override
  _SignInPageRenewedState createState() => _SignInPageRenewedState();
}

class _SignInPageRenewedState extends State<SignInPageRenewed> {
  onClickOkay() {}
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _customerNumberKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool showLoading = false;
  bool showObscureText = true;

  AlertDialog alert = AlertDialog(
    clipBehavior: Clip.hardEdge,
    title: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: AppColors.clearIconColor,
            ),
          ),
        ),
        Container(
          height: 10.46.h,
          width: 18.59.w,
          child: Image.asset(
            "assets/ellipse.png",
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
    content: Text(
      "Girdiğiniz bilgiler hatalıdır. Lütfen bilgilerinizi kontrol edip tekrar deneyiniz.",
      textAlign: TextAlign.center,
    ),
    contentTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: LocalHelper.getFontSize(12),
      color: AppColors.infoContentDialogColor,
      fontWeight: FontWeight.w500,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(bottom: 4.21.h),
        child: Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 7.06.h,
              width: 27.05.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.SignInColorGradientStart,
                    AppColors.SignInColorGradientEnd
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "Tamam",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: LocalHelper.getFontSize(14),
                    color: AppColors.primaryWightColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ],
  );

  displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onPressedPhoneIcon() {
    launch("tel://+908503330353");
  }

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
            displayDialog();

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
                  displayDialog();
                  setState(() {
                    showLoading = false;
                  });
                }
              } else {
                ///todo sign in failed
                setState(() {
                  showLoading = false;
                });
                displayDialog();
              }
            } else {
              ///todo sign in failed
              setState(() {
                showLoading = false;
              });
              displayDialog();
            }
          } on FirebaseAuthException {
            setState(() {
              showLoading = false;
            });
            displayDialog();
          }
        }
      } on FirebaseAuthException {
        setState(() {
          showLoading = false;
        });
        displayDialog();
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
          BackgroundALetter(),
          SingleChildScrollView(
            child: Column(
              children: [
                buildLogoHeader(),
                buildSignInHeader(),
                buildCustomerNumberField(),
                buildEmailField(),
                buildPasswordField(),
                NavigatorButton(
                  textLabel: "Giriş Yap",
                  onTap: onClickContinue,
                  showLoading: showLoading,
                ),
                buildForgetRows(),
                AlreadyHaveAccountRowCP(
                  secondText: "Kayıt ol",
                  onClickLogIn: onClickSignUp,
                  firstText: "Hesabın yok mu?",
                  fontSize: 11,
                ),
                StraightLine(),
                buildContactUsRow(),
                buildVersionText()
              ],
            ),
          )
        ],
      ),
    ));
  }

  Padding buildCustomerNumberField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.57.h),
      child: Form(
        key: _customerNumberKey,
        child: CustomCustomerNumberFormNew(
          controller: customerNumberController,
        ),
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.71.h),
      child: Form(
          key: _emailKey,
          child: CustomEmailFormNew(
            controller: emailController,
          )),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 3.80.h),
      child: Form(
        key: _passwordKey,
        child: CustomPasswordFormNew(
          controller: passwordController,
        ),
      ),
    );
  }

  Padding buildLogoHeader(){
    return Padding(
      padding: EdgeInsets.only(
        top: 9.h,
        bottom: 1.5.h,
      ),
      child: Container(
          height: 7.h,
          width: 60.w,
          child: Image.asset("assets/ileka_header_ex.png")),
    );
  }
  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.h
      ),
      child: Center(
        child: Text(
          'Giriş yap',
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
      padding: EdgeInsets.only(top: 0.679.h, bottom: 4.21.h),
      child: Center(
        child: Text(
          'Hesabına giriş yap',
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

  Row buildContactUsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressedPhoneIcon,
          icon: Icon(
            Icons.phone,
            color: AppColors.phoneColor,
          ),
        ),
        Text(
          'İletişim Merkezi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: const Color(0xff6f6f6f),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Center buildVersionText() {
    return Center(
      child: Text(
        "İleka Ekstre 1.0.0",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(10),
          color: const Color(0xff7b7b7b),
        ),
      ),
    );
  }

  Padding buildForgetRows() {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.44.h,
        right: 7.72.w,
        left: 7.72.w,
        bottom: 8.02.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildForgetCustomerRow(),
          buildForgetPasswordRow(),
        ],
      ),
    );
  }

  InkWell buildForgetCustomerRow() {
    return InkWell(
      onTap: onClickForgetCustomerNumber,
      child: Text(
        'Müşteri numaramı unuttum',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          color: const Color(0xff7b7b7b),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  InkWell buildForgetPasswordRow() {
    return InkWell(
      onTap: onClickForgetPassword,
      child: Text(
        'Şifremi unuttum',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          color: const Color(0xffdb2820),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
