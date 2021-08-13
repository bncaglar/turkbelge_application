import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_verified_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

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
  final failedToSignIn = SnackBar(
    content: Text('Bir hata oluştu!'),
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
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
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
            RegistrationPageHeader(
              addBackButton: true,
              subText: AppLocalizations.of(context).resetYourCustomerNumber,
              headerText: AppLocalizations.of(context).forgotMyCustomerNumber,
            ),
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
        buildPhoneNumberField(),
        buildResetButton(),
        enterYourCredentialsText(),
      ],
    );
  }

  Padding buildPhoneNumberField() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
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

  NavigationButton buildResetButton() {
    return NavigationButton(
      navigationButtonText: "Devam",
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
        height: 6.h,
        child: Center(
          child: Text(
            "Telefon numaranı girdikten sonra gelen kodu girerek müşteri numaranı öğrenebilirsin.",
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

  Column showVerificationCodeField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        countDown(),
        buildEnterCodeField(),
        builddd(),
        enterCodeText(),
      ],
    );
  }

  Container countDown() {
    return Container(
      height: 130,
      width: 130,
      child: CountDownProgressIndicator(
        strokeWidth: 5,
        controller: countDownController,
        valueColor: AppColors.newColor4Background,
        backgroundColor: AppColors.primaryGreyColor.withOpacity(0.7),
        initialPosition: 1,
        duration: 120,
        text: 'Saniye',
        onComplete: () {
          Navigator.pushReplacementNamed(context, SignInPage.routeName);
        },
      ),
    );
  }

  Padding buildEnterCodeField() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Form(
          key: _codeKey,
          child: EnterCodeForm(
            controller: codeSentController,
            labelText: AppLocalizations.of(context).enterCode,
          ),
        ),
      ),
    );
  }

  NavigationButton builddd() {
    return NavigationButton(
      backgroundColor: AppColors.newColor4Background,
      navigationButtonText: AppLocalizations.of(context).continueText,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: () {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: codeSentController.text);
        signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      margin: EdgeInsets.only(top: 3.754.h, left: 5.w, right: 5.w),
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
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
          }
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
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
          }
        }
      } else {
        ///user is not logged in(in such cases entered sms code is not correct or connection is interrupted)
        ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
    }
  }

  Padding enterCodeText() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 5.h,
        child: Center(
          child: Text(
            "Telefon numarana gelen kodu girerek müşteri numaranı öğrenebilirsin",
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

class ForgetCustomerNumberPhoneAuthArguments {
  String? tcknOrVknNumber;
  String? userEmail;
  String? userPassword;

  ForgetCustomerNumberPhoneAuthArguments(
      {required this.tcknOrVknNumber,
      required this.userEmail,
      required this.userPassword});
}
