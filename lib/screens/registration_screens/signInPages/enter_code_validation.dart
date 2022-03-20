import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/registration_screens/signInPages/enter_6_digit_pass.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

class EnterCodeValidationPage extends StatefulWidget {
  static const routeName = '/EnterCodeValidationPage';
  final String codeSent;
  final String email;
  final String password;
  final String customerNumber;
  final bool isUserAdmin;
  final bool checkedValue;
  final String phoneNumber;

  EnterCodeValidationPage(
      {required this.codeSent,
      required this.email,
      required this.password,
      required this.customerNumber,
      required this.isUserAdmin,
      required this.checkedValue,
      required this.phoneNumber});

  @override
  _EnterCodeValidationPageState createState() =>
      _EnterCodeValidationPageState();
}

class _EnterCodeValidationPageState extends State<EnterCodeValidationPage> {
  final log = Logger();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final countDownController = CountDownController();
  bool showLoading = false;
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();

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

  onClickContinue() async {
    log.i("onClickContinue started");
    try {
      if (_codeKey.currentState!.validate()) {
        ///check if codes are match
        if (codeSentController.text.trim() == widget.codeSent) {
          ///check if user is admin
          if (widget.isUserAdmin == true) {
            ///user is Admin

            ///check if user wants to save their login info
            if (widget.checkedValue == true) {
              Navigator.pushReplacementNamed(
                context,
                EnterSixDigitPassword.routeName,
                arguments: EnterSixDigitPassArguments(
                    customerNumber: widget.customerNumber,
                    email: widget.email,
                    password: widget.password),
              );
            } else {
              ///navigate SubUser to the homepage
              Navigator.pushReplacementNamed(
                context,
                FirstNavigation.routeName,
                arguments: FirstNavigationArguments(
                  email: widget.email,
                  isUserAdmin: true,
                  customerNumber: widget.customerNumber,
                ),
              );
            }
          } else {
            ///user is SubUser

            ///get SubUser phoneNumber
            String? getPhoneNumber =
                await FireStoreService().verifyPhoneNumberForSubUser(
              widget.customerNumber,
              widget.email,
            );
            if (getPhoneNumber == "-") {
              ///SubUser doesnt have phoneNumber stored

              ///save SubUser phoneNumber to the FireStore
              await FireStoreService().updateSubUserPhoneNumber(
                  widget.customerNumber, widget.email, widget.phoneNumber);

              ///check if user wants to save their login info
              if (widget.checkedValue == true) {
                Navigator.pushReplacementNamed(
                  context,
                  EnterSixDigitPassword.routeName,
                  arguments: EnterSixDigitPassArguments(
                      customerNumber: widget.customerNumber,
                      email: widget.email,
                      password: widget.password),
                );
              } else {
                ///navigate SubUser to the homepage
                Navigator.pushReplacementNamed(
                  context,
                  FirstNavigation.routeName,
                  arguments: FirstNavigationArguments(
                    email: widget.email,
                    isUserAdmin: false,
                    customerNumber: widget.customerNumber,
                  ),
                );
              }
            } else {
              ///check if user wants to save their login info
              if (widget.checkedValue == true) {
                Navigator.pushReplacementNamed(
                  context,
                  EnterSixDigitPassword.routeName,
                  arguments: EnterSixDigitPassArguments(
                      customerNumber: widget.customerNumber,
                      email: widget.email,
                      password: widget.password),
                );
              } else {
                ///navigate SubUser to the homepage

                Navigator.pushReplacementNamed(
                  context,
                  FirstNavigation.routeName,
                  arguments: FirstNavigationArguments(
                    email: widget.email,
                    isUserAdmin: false,
                    customerNumber: widget.customerNumber,
                  ),
                );
              }
            }
          }
        } else {
          ///throw error(code is wrong)
          ///todo
          displayDialog();
        }
      }
    } catch (e) {
      print(e.toString());
      displayDialog();
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
            buildForgetPasswordBody(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildForgetPasswordBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: showOtpState(),
      ),
    );
  }

  Column showOtpState() {
    return Column(
      children: <Widget>[
        buildSignInHeader(),
        buildSignInToAccountText(),
        countDown(),
        buildEnterCodeField(),
        buildNavigatorButton(),
        enterCodeText(),
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
          'Telefon Numaranı Doğrula',
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
      padding: EdgeInsets.only(top: 0.679.h, bottom: 7.21.h),
      child: Center(
        child: Text(
          'Kodu gir',
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

  Container countDown() {
    return Container(
      height: 19.76.h,
      width: 19.76.h,
      child: CountDownProgressIndicator(
        strokeWidth: 10,
        controller: countDownController,
        valueColor: AppColors.countDownBackgroundColor,
        backgroundColor: AppColors.SignInColorGradientStart,
        initialPosition: 1,
        duration: 120,
        text: 'Saniye',
        timeTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.infoContentDialogColor,
          fontWeight: FontWeight.w600,
        ),
        onComplete: () {
          ///todo
        },
      ),
    );
  }

  Padding buildEnterCodeField() {
    return Padding(
      padding: EdgeInsets.only(
          top: 4.75.h, left: 7.72.w, right: 7.72.w, bottom: 3.80.h),
      child: Form(
        key: _codeKey,
        child: EnterCodeFormNew(
          controller: codeSentController,
        ),
      ),
    );
  }

  NavigatorButton buildNavigatorButton() {
    return NavigatorButton(
        showLoading: showLoading, onTap: onClickContinue, textLabel: "Devam");
  }

  Padding enterCodeText() {
    return Padding(
      padding:
          EdgeInsets.only(top: 2.44.h, left: 6.w, right: 6.w, bottom: 15.08.h),
      child: Text(
        "Telefon numarana gelen kodu girerek giriş yapabilirsin.",
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

class EnterCodeValidationPageArguments {
  final String codeSent;
  final String email;
  final String password;
  final String customerNumber;
  final bool isUserAdmin;
  final String phoneNumber;
  final bool checkedValue;

  EnterCodeValidationPageArguments(
      {required this.codeSent,
      required this.email,
      required this.password,
      required this.customerNumber,
      required this.isUserAdmin,
      required this.checkedValue,
      required this.phoneNumber});
}
