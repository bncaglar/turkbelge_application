import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/second_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/already_have_account_text.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/checkIfTCKNvalid.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/form/customer_number_form.dart';
import 'package:turkbelge_application/widgets/form/enter_code_form.dart';
import 'package:turkbelge_application/widgets/form/tckn_or_vkn_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

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
        await FireStoreService().firstStepCreateUserInDB(
            user.uid,
            widget.userEmail!,
            userTcknNumber!,
            userVknNumber!,
            phone!,
            customerNumberController.text);
        await FireStoreService().secondStepCreateUserInDB(
            user.uid,
            widget.userName!,
            widget.userEmail!,
            customerNumberController.text,
            userTcknNumber!,
            userVknNumber!,
            phone!);

        Navigator.pushReplacementNamed(
          context,
          SecondStepOfRegistration.routeName,
          arguments: SecondStepOfRegistrationArguments(
              userVKN: userVknNumber,
              userTCKN: userTcknNumber,
              userPhoneNumber: phone,
              userCustomerNumber: customerNumberController.text,
              userName: widget.userName,
              userEmail: widget.userEmail,
              userPassword: widget.userPassword),
        );
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
      });
      print("xxxxxx");
      ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
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
        print(validateCustomerNumberWithTCKN);
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
        ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
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

  final _phoneNumberKey = GlobalKey<FormState>();

  onClickLogIn() {
    log.i("onClickLogIn started");
    Navigator.pushNamed(context, SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: wholeBody(),
              ),
      ),
    );
  }

  Container wholeBody() {
    return Container(
      height: 95.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegistrationPageHeader(
            addBackButton: true,
            subText: AppLocalizations.of(context).createANewAccount,
            headerText: AppLocalizations.of(context).createAccount,
          ),
          currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? buildFirstStepBody()
              : buildBody2(),
          AlreadyHaveAnAccountText(
            onClickHighlightedText: () {
              onClickLogIn();
            },
            highlightedText: AppLocalizations.of(context).logIn,
            normalText: AppLocalizations.of(context).alreadyHaveAnAccount,
          ),
        ],
      ),
    );
  }

  Container buildFirstStepBody() {
    return Container(
      height: 55.h,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildPhoneNumberField(),
            enterYourCredentialsText(),
          ],
        ),
      ),
    );
  }

  Padding buildPhoneNumberField() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Form(
          key: _phoneNumberKey,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                firstStepBody(),
              ],
            ),
          )),
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
            AppLocalizations.of(context).firstStepText,
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

  Column firstStepBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildCustomerNumberField(),
        buildTcknOrVkn(),
        InternationalPhoneNumberInput(
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
        buildContinueNtb()
      ],
    );
  }

  Padding buildCustomerNumberField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
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

  Padding buildTcknOrVkn() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _tcknOrVknKey,
          child: TcknOrVknForm(
            inputChangedValue: userTcknNumber,
            controller: tcknOrVknController,
            labelText: AppLocalizations.of(context).tcknOrVkn,
            onEditingComplete: () {},
          ),
        ),
      ),
    );
  }

  NavigationButton buildContinueNtb() {
    return NavigationButton(
      backgroundColor: AppColors.newColor4Background,
      navigationButtonText: AppLocalizations.of(context).continueText,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinueFirstStep,
      margin: EdgeInsets.only(
        top: 3.754.h,
      ),
    );
  }

  Column buildWholeBody2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RegistrationPageHeader(
          addBackButton: true,
          subText: AppLocalizations.of(context).createANewAccount,
          headerText: AppLocalizations.of(context).createAccount,
        ),
        buildBody2(),
        AlreadyHaveAnAccountText(
          onClickHighlightedText: () {
            onClickLogIn();
          },
          highlightedText: AppLocalizations.of(context).logIn,
          normalText: AppLocalizations.of(context).alreadyHaveAnAccount,
        ),
      ],
    );
  }

  Column buildBody2() {
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

  Padding enterCodeText() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 5.h,
        child: Center(
          child: Text(
            AppLocalizations.of(context).secondStepText,
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
