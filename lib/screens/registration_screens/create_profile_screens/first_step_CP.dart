import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/second_step_of_registration.dart';
import 'package:turkbelge_application/services/checkIfTCKNvalid.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/tckn_or_vkn_form_new.dart';

import '../signin_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class FirstStepCP extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userPassword;

  FirstStepCP(
      {required this.userEmail,
        required this.userName,
        required this.userPassword});
  @override
  _FirstStepCPState createState() => _FirstStepCPState();
}

class _FirstStepCPState extends State<FirstStepCP> {
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
  bool showLoading = false;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final countDownController = CountDownController();
  String? verificationId;
  bool checkUserIsPreApplied = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
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
            userEmail: widget.userEmail,),
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
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: [
            BackgroundALetter(),
            showLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: buildBody(),
                  ),
          ],
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildSignInHeader(),
        buildSignInToAccountText(),
        TCKNVKNFormNew(controller: tcknOrVknController),

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
            color: const Color(0xff686868),
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
            color: const Color(0xff707070),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
