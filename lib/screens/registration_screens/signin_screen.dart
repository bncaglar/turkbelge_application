import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/already_have_account_text.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/form/customer_number_form.dart';
import 'package:turkbelge_application/widgets/form/email_form.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/password_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';
import 'creating_profile/initial_step_of_registration.dart';
import 'forget_screens/forget_customer_number/forget_customer_number.dart';
import 'forget_screens/forget_password/forget_password_screen.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/SignInPage';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final failedToSignIn = SnackBar(
    content: Text('Bilgilerinizi kontrol edip tekrar deneyiniz!'),
    action: SnackBarAction(
      label: 'Tekrar dene',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    backgroundColor: Colors.red,
  );
  bool sozlesmeDurumu = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _customerNumberKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  bool showLoading = false;
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  onClickForgetCustomerNumber() {
    log.i("onClickForgetCustomerNumber started");
    Navigator.pushNamed(context, ForgetCustomerNumberPage.routeName);
  }

  onClickForgetPassword() {
    log.i("onClickForgetPassword started");
    Navigator.pushNamed(context, ForgetPasswordPage.routeName);
  }

  onClickSignUp() {
    Navigator.pushNamed(context, InitialStepOfRegistration.routeName);
  }

  onClickContinue() async {
    log.i("onClickContinue started");
    if (_customerNumberKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate()) {
      setState(() {
        showLoading = true;
      });
      try {
        await AuthenticationService(_firebaseAuth).signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          String validateCustomerNumber = await FireStoreService()
              .verifyEmailAddressWithCustomerNumber(
                  customerNumberController.text, user.uid);
          if (validateCustomerNumber == emailController.text) {
            Navigator.pushReplacementNamed(context, FirstNavigation.routeName);
            setState(() {
              showLoading = false;
            });
            log.i("giriş başarılı :-)))");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
            setState(() {
              showLoading = false;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
          setState(() {
            showLoading = false;
          });
        }
      } on FirebaseAuthException {
        ScaffoldMessenger.of(context).showSnackBar(failedToSignIn);
        setState(() {
          showLoading = false;
        });
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
            : buildBodyColumn(),
      ),
    );
  }

  SingleChildScrollView buildBodyColumn() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegistrationPageHeader(
            addBackButton: false,
            subText: AppLocalizations.of(context).loginToYourAccount,
            headerText: AppLocalizations.of(context).logIn,
          ),
          buildSignInBody(),
          AlreadyHaveAnAccountText(
              onClickHighlightedText: onClickSignUp,
              highlightedText: AppLocalizations.of(context).signUp,
              normalText: AppLocalizations.of(context).doNotHaveAnAccount),
        ],
      ),
    );
  }

  Padding buildForgetInfoRow() {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 5.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildForgetCustomerNumberField(),
            buildForgetPasswordField(),
          ],
        ),
      ),
    );
  }

  InkWell buildForgetCustomerNumberField() {
    return InkWell(
      onTap: () {
        onClickForgetCustomerNumber();
      },
      child: Text(
        AppLocalizations.of(context).forgotMyCustomerNumber,
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.backgroundPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  InkWell buildForgetPasswordField() {
    return InkWell(
      onTap: () {
        onClickForgetPassword();
      },
      child: Text(
        AppLocalizations.of(context).forgotMyPassword,
        style: TextStyle(
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.backgroundPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Container buildSignInBody() {
    return Container(
      height: 65.h,
      width: double.infinity,
      child: Column(
        children: [
          buildCustomerNumberField(),
          buildEmailField(),
          buildPasswordField(),
          rememberMeBox(),
          buildLogInButton(),
          buildForgetInfoRow(),
        ],
      ),
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

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _emailKey,
          child: EmailForm(
            labelText: AppLocalizations.of(context).emailLabelText,
            controller: emailController,
          ),
        ),
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _passwordKey,
          child: PasswordForm(
            labelText: AppLocalizations.of(context).passwordLabelText,
            controller: passwordController,
          ),
        ),
      ),
    );
  }

  NavigationButton buildLogInButton() {
    return NavigationButton(
      navigationButtonText: AppLocalizations.of(context).logIn,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinue,
      margin: EdgeInsets.only(
        left: 4.69.w,
        right: 4.69.w,
      ),
    );
  }

  Container rememberMeBox() {
    ///todo remember me box will be used to keep user logged in, in accordance with the preference of the user
    return Container(
      height: 8.h,
      width: double.infinity,
      child: CheckboxListTile(
        activeColor: AppColors.newColor4Background,
        title: Text(
          "Hesabımı açık tut",
          style: TextStyle(
            fontSize: LocalHelper.getFontSize(13),
            color: AppColors.backgroundPrimaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        value: sozlesmeDurumu,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? data) async{
          final prefs = await SharedPreferences.getInstance();
          bool myBool = prefs.getBool('state') ?? false;
          setState(() {
            sozlesmeDurumu = data!;
            myBool = sozlesmeDurumu;
            prefs.setBool('state', myBool);
            print(myBool);
          });
        },
      ),
    );
  }
}
