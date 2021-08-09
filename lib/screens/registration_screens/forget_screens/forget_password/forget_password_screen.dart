import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_password/enter_new_password_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/widgets/form/customer_number_form.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

import '../../signin_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class ForgetPasswordPage extends StatefulWidget {
  static const routeName = '/ForgetPasswordPage';

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final log = getLogger();
  bool showLoading = false;
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  final countDownController = CountDownController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  String? verificationId;
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
    log.i("onClickContinue");
    if (_customerNumberKey.currentState!.validate() &&
        formKey.currentState!.validate()) {
      try {
        setState(() {
          showLoading = true;
        });
        String validateCustomerNumber = await FireStoreService()
            .verifyPhoneNumberWithCustomerNumber(customerNumberController.text);
        if (validateCustomerNumber == "Error") {
          setState(() {
            showLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
        } else if (validateCustomerNumber == phone) {
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
                currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                this.verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) async {},
          );
        } else {
          setState(() {
            showLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
          });
        }
      } on FirebaseException {
        var error = "Error";
        setState(() {
          showLoading = false;
        });
        return error;
      }
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();

  final _customerNumberKey = GlobalKey<FormState>();
  String? phone;
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildForgetPasswordBody(),
      ),
    );
  }

  SingleChildScrollView buildForgetPasswordBody() {
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
            currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? showFormState()
                : showOtpState(),
          ],
        ),
      ),
    );
  }

  Column showFormState() {
    return Column(
      children: [
        buildCustomerNumberField(),
        buildPhoneNumberField(),
        buildResetButton(),
        enterYourCredentialsText()
      ],
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

  Padding buildPhoneNumberField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
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
            "Müşteri ve telefon numaranı girdikten sonra gelen kodu girerek şifreni sıfırlayabilirsin.",
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

  Column showOtpState() {
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
        //todo if user is exist
        //todo navigate to the next step
        Navigator.pushReplacementNamed(
            context, EnterNewPasswordScreen.routeName);
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
            "Telefon numarana gelen kodu girerek şifreni sıfırlayabilirsin",
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
