import 'dart:io';

import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/create_profile_screens/components/alreadyHaveAccountRow.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/second_step_of_registration.dart';
import 'package:turkbelge_application/services/checkIfTCKNvalid.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/Straight_line.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/customer_number_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/enter_code_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/tckn_or_vkn_form_new.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

import '../../noInternetConnectionPage.dart';
import '../signin_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class FirstStepOfRegistration extends StatefulWidget {
  static const routeName = '/FirstStepOfRegistration';
  final String? userName;
  final String? userEmail;
  final String? userPassword;

  FirstStepOfRegistration(
      {required this.userEmail,
      required this.userName,
      required this.userPassword});

  @override
  _FirstStepOfRegistrationState createState() =>
      _FirstStepOfRegistrationState();
}

class _FirstStepOfRegistrationState extends State<FirstStepOfRegistration> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final countDownController = CountDownController();
  String? verificationId;
  bool checkUserIsPreApplied = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
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
      AuthCredential credential = EmailAuthProvider.credential(
          email: widget.userEmail!, password: widget.userPassword!);
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      User? user = _firebaseAuth.currentUser;
      await user!.linkWithCredential(credential);
      await user.sendEmailVerification();
      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        //todo if user is exist
        //todo navigate to the next step
        String endDate =
            await FireStoreService().getEndDate(customerNumberController.text);
        String paketAdi =
            await FireStoreService().getPaketAdi(customerNumberController.text);
        String startDate = await FireStoreService()
            .getStartDate(customerNumberController.text);
        String registrationDate = await FireStoreService()
            .getRegistrationDate(customerNumberController.text);

        await FireStoreService().firstStepCreateUserInDB(
            user.uid,
            widget.userEmail!,
            userTcknNumber!,
            userVknNumber!,
            phone!,
            customerNumberController.text);

        await FireStoreService().secondStepCreateUserInDB(
            widget.userName!,
            widget.userEmail!,
            customerNumberController.text,
            userTcknNumber!,
            userVknNumber!,
            phone!,
            endDate,
            registrationDate,
            paketAdi,
            startDate);
        Navigator.pushReplacementNamed(
          context,
          SecondStepOfRegistration.routeName,
          arguments: SecondStepOfRegistrationArguments(
            userName: widget.userName,
            userEmail: widget.userEmail,
          ),
        );
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
      });
      print("xxxxxx");
      displayDialog();
    }
  }

  TextEditingController tcknOrVknController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  final _customerNumberKey = GlobalKey<FormState>();
  final _tcknOrVknKey = GlobalKey<FormState>();

  onClickContinueFirstStep() async {
    log.i("onClickContinue started");
    if (_tcknOrVknKey.currentState!.validate() &&
        formKey.currentState!.validate() &&
        _customerNumberKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      if (tcknOrVknController.text.length == 10) {
        setState(() {
          userVknNumber = tcknOrVknController.text;
        });
      } else if (tcknOrVknController.text.length == 11) {
        setState(() {
          userTcknNumber = tcknOrVknController.text;
        });
      }
      print("tckn = " + userTcknNumber!);
      print("vkn = " + userVknNumber!);
      //todo check if customer number is exist in the preapplieduser collection in firestore
      if (tcknOrVknController.text.length == 11) {
        String validateCustomerNumberWithTCKN = await FireStoreService()
            .verifyCustomerNumberInPreAppliedUserCollectionWithTCKN(
                customerNumberController.text);
        if (validateCustomerNumberWithTCKN == "Error") {
          setState(() {
            checkUserIsPreApplied = false;
            showLoading = false;
          });
        } else if (validateCustomerNumberWithTCKN == userTcknNumber) {
          bool? isTCKNVerified =
              await CheckIfTCKNValid().checkTCKN(userTcknNumber);
          if (isTCKNVerified == true) {
            setState(() {
              checkUserIsPreApplied = true;
            });
          } else {
            setState(() {
              checkUserIsPreApplied = false;
            });
          }
        } else {
          setState(() {
            checkUserIsPreApplied = false;
            showLoading = false;
          });
        }
      } else if (tcknOrVknController.text.length == 10) {
        String validateCustomerNumberWithVKN = await FireStoreService()
            .verifyCustomerNumberInPreAppliedUserCollectionWithVKN(
                customerNumberController.text);
        print(validateCustomerNumberWithVKN);

        if (validateCustomerNumberWithVKN == "Error") {
          setState(() {
            checkUserIsPreApplied = false;
            showLoading = false;
          });
        } else if (validateCustomerNumberWithVKN == userVknNumber) {
          setState(() {
            checkUserIsPreApplied = true;
          });
        } else {
          setState(() {
            checkUserIsPreApplied = false;
            showLoading = false;
          });
        }
      } else {
        setState(() {
          showLoading = false;
        });
      }
      if (checkUserIsPreApplied == true) {
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
          codeAutoRetrievalTimeout: (verificationId) async {
            displayDialog();
          },
        );
      } else {
        displayDialog();
      }
    }
  }

  final log = getLogger();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'TR');

  String? phone;
  String? userVknNumber = "";
  String? userTcknNumber = "";

  onClickLogIn() {
    log.i("onClickLogIn started");
    Navigator.pushNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: checkInternetConnection(),
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.data == false) {
          return NoInternetConnectionPage();
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.primaryWightColor,
              body: showLoading
                  ? Stack(
                      children: [
                        BackgroundALetter(),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        BackgroundALetter(),
                        SingleChildScrollView(
                          child: buildBody(),
                        ),
                      ],
                    ),
            ),
          );
        }
      },
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildSignInHeader(),
        buildSignInToAccountText(),
        currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
            ? buildFirstStepBody()
            : buildBody2(),
        StraightLine(),
        AlreadyHaveAccountRowCP(
          topPadding: 1.29.h,
          onClickLogIn: onClickLogIn,
          secondText: 'Giriş Yap',
          firstText: 'Zaten hesabın var mı?',
          bottomPadding: 0,
          fontSize: 12,
        ),
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
          'Hesap Oluştur',
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
      padding: EdgeInsets.only(top: 0.679.h, bottom: 7.20.h),
      child: Center(
        child: Text(
          'Yeni bir hesap oluştur',
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

  SingleChildScrollView buildFirstStepBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildFirstStepBodyNew(),
          SizedBox(
            height: 15.20.h,
          )
        ],
      ),
    );
  }

  Form buildFirstStepBodyNew() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          firstStepBody(),
        ],
      ),
    );
  }

  Column firstStepBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildCustomerNumberField(),
        buildTcknOrVkn(),
        buildPhoneNumberForm(),
        NavigatorButton(
            showLoading: showLoading,
            onTap: onClickContinueFirstStep,
            textLabel: "Hesap Oluştur"),
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

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.44.h),
      child: Text(
        "Türkiye Cumhuriyeti kimlik numaranı ya da vergi kimlik numaranı girerek hesabını oluşturmaya devam edebilirsin.",
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

  Padding buildCustomerNumberField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.h),
      child: Form(
        key: _customerNumberKey,
        child: CustomCustomerNumberFormNew(
          controller: customerNumberController,
        ),
      ),
    );
  }

  Padding buildTcknOrVkn() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 4.w),
      child: Form(
        key: _tcknOrVknKey,
        child: TCKNVKNFormNew(controller: tcknOrVknController),
      ),
    );
  }

  Column buildBody2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
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
        "Telefon numarana gelen kodu girerek hesabını oluşturabilirsin.",
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FirstStepOfRegistrationArguments {
  final String? userName;
  final String? userEmail;
  final String? userPassword;

  FirstStepOfRegistrationArguments(
      {required this.userName,
      required this.userEmail,
      required this.userPassword});
}
