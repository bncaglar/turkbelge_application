import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

// ignore: must_be_immutable
class EnterNewPasswordScreen extends StatefulWidget {
  static const routeName = '/EnterNewPasswordScreen';
  String customerNumber;
  String email;
  bool isAdmin;

  EnterNewPasswordScreen({
    required this.customerNumber,
    required this.email,
    required this.isAdmin,
  });

  @override
  _EnterNewPasswordScreenState createState() => _EnterNewPasswordScreenState();
}

class _EnterNewPasswordScreenState extends State<EnterNewPasswordScreen> {
  final log = getLogger();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool showLoading = false;
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

  @override
  void dispose() {
    passwordController.clear();
    newPasswordController.clear();
    super.dispose();
  }

  onClickContinue() async {
    final snackBar = SnackBar(
      content: Text("Şifreniz başarıyla değiştirildi!"),
      action: SnackBarAction(
        label: 'Tamam',
        textColor: Colors.white,
        onPressed: () {
          setState(() {});
        },
      ),
      backgroundColor: Colors.green,
    );
    log.i("onClickContinue started");
    setState(() {
      showLoading = true;
    });
    try {
      if (_passwordKey.currentState!.validate() &&
          _newPasswordKey.currentState!.validate()) {
        await _firebaseAuth.currentUser
            ?.updatePassword(passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
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
        buildPasswordField(),
        buildConfirmPasswordField(),
        buildNavigatorBtn(),
        buildDesc()
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
          'Şifreni Değiştir',
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
          'Şifreni hemen değiştirebilirsin.',
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

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 4.h),
      child: Form(
        key: _passwordKey,
        child: CustomPasswordFormNew(
          hintText: "Şifre",
          controller: passwordController,
        ),
      ),
    );
  }

  Padding buildConfirmPasswordField() {
    return Padding(
      padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 3.80.h),
      child: Form(
        key: _newPasswordKey,
        child: CustomPasswordFormNew(
          hintText: "Şifreni tekrar gir",
          controller: newPasswordController,
          confirmPasswordController: passwordController,
        ),
      ),
    );
  }

  Padding buildNavigatorBtn() {
    return Padding(
        padding: EdgeInsets.only(right: 7.72.w, left: 7.72.w, bottom: 2.44.h),
        child: NavigatorButton(
          onTap: onClickContinue,
          showLoading: showLoading,
          textLabel: "Şifreni değiştir",
        ));
  }

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w,
        left: 6.w,
      ),
      child: Text(
        "Uygulama içerisinde şifre değiştirme işlemlerinde telefon doğrulaması yapılmaz!",
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

class EnterNewPasswordScreenArguments {
  String customerNumber;
  String email;
  bool isAdmin;

  EnterNewPasswordScreenArguments({
    required this.customerNumber,
    required this.email,
    required this.isAdmin,
  });
}
