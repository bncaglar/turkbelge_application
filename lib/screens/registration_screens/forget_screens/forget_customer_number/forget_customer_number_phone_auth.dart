import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_verified_screen.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

import '../../signin_screen.dart';

enum ForgetCustomerNumberState {
  SHOW_PHONE_INPUT_FIELD,
  SHOW_VERIFICATION_CODE_FIELD
}

class ForgetCustomerNumberPhoneAuth extends StatefulWidget {
  static const routeName = '/ForgetCustomerNumberPhoneAuth';
  final String? tcknOrVknNumber;
  final String? userEmail;
  final String? userPassword;

  ForgetCustomerNumberPhoneAuth(
      {required this.tcknOrVknNumber,
      required this.userEmail,
      required this.userPassword});

  @override
  _ForgetCustomerNumberPhoneAuthState createState() =>
      _ForgetCustomerNumberPhoneAuthState();
}

class _ForgetCustomerNumberPhoneAuthState
    extends State<ForgetCustomerNumberPhoneAuth> {
  final log = getLogger();
  ForgetCustomerNumberState currentState =
      ForgetCustomerNumberState.SHOW_PHONE_INPUT_FIELD;
  String? phone;
  String? verificationId;
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  final countDownController = CountDownController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  bool showLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AlertDialog alert = AlertDialog(
    clipBehavior: Clip.hardEdge,
    title: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: (){
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        ///check if user is logged in via phone auth
        if (widget.tcknOrVknNumber!.length == 11) {
          ///tcknOrVknNumber is TCKN
          String validateTckn =
          await FireStoreService().verifyTCKN(authCredential.user!.uid);

          ///check if TCKN is on the desired system
          if (validateTckn == widget.tcknOrVknNumber) {
            ///TODO NAVIGATE TO THE NEXT STEP
            ///todo send customer number as an email
            String? getCustomerNumber = await FireStoreService()
                .getCustomerNumber(authCredential.user!.uid);
            print(getCustomerNumber);
            await FireStoreService().sendRemindCustomerNumberEmail(
                getCustomerNumber, widget.userEmail!);
            Navigator.pushReplacementNamed(
              context,
              ForgetCustomerNumberVerifiedPage.routeName,
              arguments: ForgetCustomerNumberVerifiedPageArguments(
                  userEmail: widget.userEmail),
            );
          } else {
            ///tckn is not correct
            displayDialog();          }
        } else {
          ///tcknOrVknNumber is VKN
          String validateVkn =
          await FireStoreService().verifyVKN(authCredential.user!.uid);
          if (validateVkn == widget.tcknOrVknNumber) {
            ///check if VKN is correct
            ///TODO NAVIGATE TO THE NEXT STEP
            ///todo send customer number as an email
            String? getCustomerNumber = await FireStoreService()
                .getCustomerNumber(authCredential.user!.uid);
            print(getCustomerNumber);
            await FireStoreService().sendRemindCustomerNumberEmail(
                getCustomerNumber, widget.userEmail!);
            Navigator.pushReplacementNamed(
              context,
              ForgetCustomerNumberVerifiedPage.routeName,
              arguments: ForgetCustomerNumberVerifiedPageArguments(
                  userEmail: widget.userEmail),
            );
          } else {
            ///VKN IS NOT CORRECT
            displayDialog();
          }
        }
      } else {
        ///user is not logged in(in such cases entered sms code is not correct or connection is interrupted)
        displayDialog();
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
      });
      displayDialog();
    }
  }

  onClickContinue() async {
    log.i("onClickContinue started");
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          showLoading = true;
        });
        await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 120),
          phoneNumber: phone!,
          verificationCompleted: (phoneAuthCredential) async {
            setState(() {
              showLoading = false;
            });
          },
          verificationFailed: (verificationFailed) async {
            setState(() {
              showLoading = false;
            });
            displayDialog();
          },
          codeSent: (verificationId, resendingToken) async {
            setState(() {
              showLoading = false;
              currentState =
                  ForgetCustomerNumberState.SHOW_VERIFICATION_CODE_FIELD;
              this.verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) async {},
        );
      } on FirebaseException {
        ///THROW ERROR
        displayDialog();
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
            : buildForgetCustomerNumberPhoneAuthBody(),
      ),
    );
  }

  SingleChildScrollView buildForgetCustomerNumberPhoneAuthBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            currentState == ForgetCustomerNumberState.SHOW_PHONE_INPUT_FIELD
                ? showPhoneInputField()
                : showVerificationCodeField()
          ],
        ),
      ),
    );
  }

  Column showPhoneInputField() {
    return Column(
      children: [
        buildSignInHeader(),
        buildSignInToAccountText(),
        buildPhoneNumberForm(),
        buildNavigatorBtn(),
        buildDesc(),
      ],
    );
  }

  Padding buildPhoneNumberForm(){
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 3.80.h),
      child: InternationalPhoneNumberInput(
        locale: "tr",
        hintText: "Telefon numarası",
        errorMessage: "Geçersiz telefon numarası",
        onInputChanged: (PhoneNumber number) {
          setState(() {
            phone = number.phoneNumber;
          });
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: controller,
        formatInput: false,
        keyboardType:
        TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: OutlineInputBorder(),
      ),
    );
  }

  Padding buildNavigatorBtn(){
    return Padding(
      padding: EdgeInsets.only(
        right: 7.72.w, left: 7.72.w, bottom: 3.80.h
      ),
      child: NavigatorButton(
        textLabel: "Devam",
        onTap: onClickContinue,
        showLoading: showLoading,
      ),
    );
  }

  Padding buildDesc(){
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w, left: 6.w,
      ),
      child: Text(
        "Müşteri ve telefon numaranı girdikten sonra gelen kodu girerek şifreni sıfırlayabilirsin. .",
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

  Column showVerificationCodeField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildSignInHeader(),
        buildSignInToAccountText(),
        countDown(),
        buildEnterCodeField(),
        NavigatorButton(
            showLoading: showLoading,
            onTap: () {
              PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!,
                  smsCode: codeSentController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            textLabel: "Devam"),
        enterCodeText(),
      ],
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
          Navigator.pushReplacementNamed(context, SignInPage.routeName);
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

  Padding enterCodeText() {
    return Padding(
      padding:
      EdgeInsets.only(top: 2.44.h, left: 6.w, right: 6.w, bottom: 15.08.h),
      child: Text(
        "Telefon numarana gelen kodu girerek müşteri numaranı öğrenebilirsin.",
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

  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 9.10.h,
      ),
      child: Center(
        child: Text(
          'Müşteri Numaramı Unuttum',
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
          'Müşteri numaranı anında elde et',
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
}

class ForgetCustomerNumberPhoneAuthArguments {
  String? tcknOrVknNumber;
  String? userEmail;
  String? userPassword;

  ForgetCustomerNumberPhoneAuthArguments(
      {required this.tcknOrVknNumber,
      required this.userEmail,
      required this.userPassword});
}
