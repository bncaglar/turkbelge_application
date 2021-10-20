import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_phone_auth.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/tckn_or_vkn_form_new.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

class ResetCustomerNumber extends StatefulWidget {
  @override
  _ResetCustomerNumberState createState() => _ResetCustomerNumberState();
}

class _ResetCustomerNumberState extends State<ResetCustomerNumber> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tcknOrVknController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _tcknOrVknKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;

  AlertDialog alert = AlertDialog(
    titlePadding: EdgeInsets.only(top: 1.90.h, right: 3.38.w, left: 3.38.w),
    clipBehavior: Clip.hardEdge,
    title: Column(
      children: [
        InkWell(
          onTap: () {
            ///navigate back
            Get.back();
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 3.38.w),
              child: Container(
                height: 1.63.h,
                width: 2.89.w,
                child: Icon(
                  Icons.clear,
                  color: AppColors.clearIconColor,
                ),
              ),
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
    if (_tcknOrVknKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&

        ///CHECK IF ALL THE VALIDATORS ARE NOT THROWING ERROR
        _passwordKey.currentState!.validate()) {
      try {
        setState(() {
          showLoading = true;
        });
        await AuthenticationService(_auth).signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        User? user = _auth.currentUser;
        print(tcknOrVknController.text);
        if (tcknOrVknController.text.length == 11) {
          ///check if the input is tckn or vkn
          String verifyTckn = await FireStoreService().verifyTCKN(user!.uid);
          if (verifyTckn == tcknOrVknController.text) {
            ///check if the tckn is valid
            ///todo navigate user to the next step
            Navigator.pushNamed(
                context, ForgetCustomerNumberPhoneAuth.routeName,
                arguments: ForgetCustomerNumberPhoneAuthArguments(
                  tcknOrVknNumber: tcknOrVknController.text,
                  userEmail: emailController.text,
                  userPassword: passwordController.text,
                ));
            setState(() {
              showLoading = false;
            });
          } else {
            ///TCKN IS NOT VALID!!
            displayDialog();
            setState(() {
              showLoading = false;
            });
          }
        } else {
          ///input is VKN
          ///check for the vkn number
          String verifyVKN = await FireStoreService().verifyVKN(user!.uid);
          if (verifyVKN == tcknOrVknController.text) {
            ///todo navigate user to the next step
            Navigator.pushNamed(
                context, ForgetCustomerNumberPhoneAuth.routeName,
                arguments: ForgetCustomerNumberPhoneAuthArguments(
                  tcknOrVknNumber: tcknOrVknController.text,
                  userEmail: emailController.text,
                  userPassword: passwordController.text,
                ));
            setState(() {
              showLoading = false;
            });
          } else {
            ///VKN IS NOT VALID!!
            displayDialog();
            setState(() {
              showLoading = false;
            });
          }
        }
      } on FirebaseException {
        ///todo throw error
        displayDialog();
        setState(() {
          showLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundALetter(),
          SingleChildScrollView(
            child: Column(
              children: [
                buildSignInHeader(),
                buildSignInToAccountText(),
                buildTCKNorVKNForm(),
                buildEmailForm(),
                buildPasswordForm(),
                buildNavigatorBtn(),
                buildDesc(),
              ],
            ),
          )
        ],
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

  Padding buildTCKNorVKNForm() {
    return Padding(
      padding: EdgeInsets.only(
          right: 7.72.w, left: 7.72.w, top: 7.20.h, bottom: 4.75.h),
      child: Form(
        key: _tcknOrVknKey,
        child: TCKNVKNFormNew(
          controller: tcknOrVknController,
        ),
      ),
    );
  }

  Padding buildEmailForm() {
    return Padding(
      padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 4.75.h),
      child: Form(
        key: _emailKey,
        child: CustomEmailFormNew(
          controller: emailController,
        ),
      ),
    );
  }

  Padding buildPasswordForm() {
    return Padding(
      padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 3.80.w),
      child: Form(
        key: _passwordKey,
        child: CustomPasswordFormNew(
          controller: passwordController,
        ),
      ),
    );
  }

  Padding buildNavigatorBtn() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.44.h),
      child: NavigatorButton(
        onTap: onClickContinue,
        textLabel: "Devam",
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
        "Türkiye Cumhuriyeti kimlik numaranı veya vergi kimlik numaranı e-postan ile girip müşteri numaranı elde edebilirsin.",
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
