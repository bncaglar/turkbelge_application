import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/services/generator/randomCustomerNumberGenerator.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/enter_code_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

enum ChangePasswordState {
  SHOW_ENTER_EMAIL_STATE,
  SHOW_ENTER_CODE_STATE,
}

class ChangeEmailScreen extends StatefulWidget {
  static const routeName = '/ChangeEmailScreen';
  String customerNumber;
  String email;
  bool isAdmin;

  ChangeEmailScreen({
    required this.customerNumber,
    required this.email,
    required this.isAdmin,
  });

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final log = getLogger();
  TextEditingController emailController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final countDownController = CountDownController();
  TextEditingController codeSentController = TextEditingController();
  final _codeKey = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool showLoading = false;
  ChangePasswordState currentState = ChangePasswordState.SHOW_ENTER_EMAIL_STATE;
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
  String generateCode = "";

  displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  AlertDialog alert1 = AlertDialog(
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
      "Alt kullanıcılar e-posta adreslerini değiştiremezler!",
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

  displayDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert1;
      },
    );
  }

  @override
  void dispose() {
   emailController.clear();
   codeSentController.clear();
    super.dispose();
  }

  onClickEnterCode() async {
    ///todo add displaydialog page if the informations that are provided wrong!!!

    final snackBar = SnackBar(
      content: Text("E-posta adresiniz başarıyla değiştirildi!"),
      action: SnackBarAction(
        label: 'Tamam',
        textColor: Colors.white,
        onPressed: () {
          setState(() {});
        },
      ),
      backgroundColor: Colors.green,
    );

    log.i("onClickEnterCode started!");

    setState(() {
      showLoading = true;
    });
    User? user = _firebaseAuth.currentUser;
    try {
      if (_codeKey.currentState!.validate()) {
        if (codeSentController.text == generateCode) {
          if (user != null) {
            if (widget.isAdmin) {
              await user.updateEmail(emailController.text.trim());
              await FireStoreService().updateAdminEmail(widget.customerNumber, emailController.text.trim());
              ///todo update admin email in firestore
              setState(() {
                showLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            } else {
              displayDialog1();
              setState(() {
                showLoading = false;
              });
            }
          } else {
            displayDialog();
            setState(() {
              showLoading = false;
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        } else {
          ///todo display dialog
          displayDialog();
          setState(() {
            showLoading = false;
          });
        }
      }
    } catch (err) {
      displayDialog();

      setState(() {
        showLoading = false;
      });
    }
  }

  onClickContinue() async {
    log.i("onClickContinue started");
    setState(() {
      showLoading = true;
    });
    try {
      if (_emailKey.currentState!.validate()) {
        if(widget.isAdmin){
          setState(() {
            generateCode = generateCustomerNumber();
          });
          await FireStoreService().sendResetEmail(
            emailController.text.trim(),
            generateCode,
          );
          setState(() {
            showLoading = false;
            currentState = ChangePasswordState.SHOW_ENTER_CODE_STATE;
          });
        }else{
          displayDialog1();
          setState(() {
            showLoading = false;
          });
        }
      } else {
        setState(() {
          showLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        showLoading = false;
      });
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
            buildEnterNewPasswordBody(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildEnterNewPasswordBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            buildBody(),
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
        currentState == ChangePasswordState.SHOW_ENTER_EMAIL_STATE
            ? buildEmailField()
            : buildEnterCodeState(),
        buildNavigatorBtn(),
        buildDesc()
      ],
    );
  }

  Column buildEnterCodeState() {
    return Column(
      children: [
        countDown(),
        buildEnterCodeField(),
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
          Navigator.pop(context);
        },
      ),
    );
  }

  Padding buildEnterCodeField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 7.72.w,
        right: 7.72.w,
        bottom: 2.71.h,
      ),
      child: Form(
        key: _codeKey,
        child: EnterCodeFormNew(
          controller: codeSentController,
        ),
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 7.72.w,
        right: 7.72.w,
        bottom: 2.71.h,
      ),
      child: Form(
          key: _emailKey,
          child: CustomEmailFormNew(
            controller: emailController,
          )),
    );
  }

  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 9.10.h,
      ),
      child: Center(
        child: Text(
          'E-postanı Değiştir',
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
      padding: EdgeInsets.only(top: 0.679.h, bottom: 6.80.h),
      child: Center(
        child: Text(
          currentState == ChangePasswordState.SHOW_ENTER_EMAIL_STATE
              ? 'Mail adresini hemen değiştirebilirsin.'
              : "Mail adresine gelen kodu girebilirsin",
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

  Padding buildNavigatorBtn() {
    return Padding(
        padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 2.44.h),
        child: NavigatorButton(
          onTap: currentState == ChangePasswordState.SHOW_ENTER_EMAIL_STATE
              ? onClickContinue
              : onClickEnterCode,
          showLoading: showLoading,
          textLabel: "E-postanı değiştir",
        ));
  }

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w,
        left: 6.w,
      ),
      child: Text(
        currentState == ChangePasswordState.SHOW_ENTER_EMAIL_STATE
            ? "Yeni e-posta adresine gönderilen kodu giererek e-postanı değiştirebilirsin!"
            : "E-posta adresine gelen kodu girerek hemen e-posta adresini güncelleyebilirsin!",
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

class ChangeEmailScreenArguments {
  String customerNumber;
  String email;
  bool isAdmin;

  ChangeEmailScreenArguments({
    required this.customerNumber,
    required this.email,
    required this.isAdmin,
  });
}
