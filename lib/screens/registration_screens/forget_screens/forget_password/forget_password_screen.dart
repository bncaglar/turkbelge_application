import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_password/enter_new_password_screen.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/customer_number_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

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
        String validateCustomerNumber = await FireStoreService()
            .verifyPhoneNumberWithCustomerNumber(
                customerNumberController.text, authCredential.user!.uid);
        if (validateCustomerNumber == phone) {
          //todo if user is exist
          //todo navigate to the next step
          Navigator.pushReplacementNamed(
              context, EnterNewPasswordScreen.routeName);
        }
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
      });
      displayDialog();
    }
  }

  final log = getLogger();
  bool showLoading = false;
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  final countDownController = CountDownController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  String? verificationId;
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

  onClickContinue() async {
    log.i("onClickContinue");
    if (_customerNumberKey.currentState!.validate() &&
        formKey.currentState!.validate()) {
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
              currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
              this.verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) async {},
        );
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
            : Stack(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        buildSignInHeader(),
        buildSignInToAccountText(),
        buildTCKNOrVKNForm(),
        buildPhoneNumberForm(),
        buildNavigatorBtn(),
        buildDesc(),
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
          'Şifremi Unuttum',
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
          'Şifreni hemen sıfırla',
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

  Padding buildTCKNOrVKNForm() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 4.75.h),
      child: Form(
        key: _customerNumberKey,
        child: CustomCustomerNumberFormNew(
          controller: customerNumberController,
        ),
      ),
    );
  }

  Padding buildPhoneNumberForm() {
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

  Padding buildNavigatorBtn() {
    return Padding(
        padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 2.44.h),
        child: NavigatorButton(
          onTap: onClickContinue,
          showLoading: showLoading,
          textLabel: "Devam",
        ));
  }

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w,
        left: 6.w,
      ),
      child: Text(
        "Telefon numaranı girdikten sonra gelen kodu girerek müşteri numaranı öğrenebilirsin.",
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

  NavigatorButton buildNavigatorButton() {
    return NavigatorButton(
        showLoading: showLoading,
        onTap: () {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!,
                  smsCode: codeSentController.text);
          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        textLabel: "Devam");
  }

  Padding enterCodeText() {
    return Padding(
      padding:
          EdgeInsets.only(top: 2.44.h, left: 6.w, right: 6.w, bottom: 15.08.h),
      child: Text(
        "Telefon numarana gelen kodu girerek şifreni sıfırlayabilirsin.",
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
