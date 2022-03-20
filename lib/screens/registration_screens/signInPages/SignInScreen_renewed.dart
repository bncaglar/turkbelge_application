import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/signInPages/enter_code_validation.dart';
import 'package:turkbelge_application/screens/registration_screens/signInPages/enter_phone_number_validation.dart';
import 'package:turkbelge_application/services/authentication_service.dart';
import 'package:turkbelge_application/services/firebase_firestore_service.dart';
import 'package:turkbelge_application/services/generator/randomCustomerNumberGenerator.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/Straight_line.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/formWidgets/6digit_password_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/customer_number_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../create_profile_screens/components/alreadyHaveAccountRow.dart';
import '../creating_profile/initial_step_of_registration.dart';
import '../forget_screens/forget_customer_number/forget_customer_number.dart';
import '../forget_screens/forget_password/forget_password_screen.dart';

class SignInPageRenewed extends StatefulWidget {
  static const routeName = '/SignInPageRenewed';
  @override
  _SignInPageRenewedState createState() => _SignInPageRenewedState();
}

class _SignInPageRenewedState extends State<SignInPageRenewed> {
  onClickOkay() {}
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _customerNumberKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool showLoading = false;
  bool showObscureText = true;

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

  onPressedPhoneIcon() {
    launch("tel://+908503330353");
  }

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

  onClickContinueDemo() async {
    log.i("onClickContinue started");
    try {
      ///we get the local variables from sharedPreferences
      var sp = await SharedPreferences.getInstance();

      ///email that is used to verify Firebase Auth
      String? email = sp.getString("email");

      ///customerNumber that we store in Firestore
      String? customerNumber = sp.getString("customerNumber");

      ///Password that is used to verify Firebase Auth
      String? password = sp.getString("password");

      ///Password that helps user to logged in
      String? primaryPassword = sp.getString("primaryPassword");

      ///we check if the user already saved the login info
      if (sp.containsKey("customerNumber") &&
          sp.containsKey("email") &&
          sp.containsKey("password")) {
        ///User saved their info so we will not ask them to provide their login info again

        if(_passwordKey.currentState!.validate()){
          if(primaryPassword == passwordController.text.trim()){

            setState(() {
              showLoading = true;
            });

            ///Log user into Firebase Auth
            await AuthenticationService(_firebaseAuth)
                .signIn(email: email, password: password);

            User? user = _firebaseAuth.currentUser;

            ///check if user credentials are correct
            if (user != null) {
              ///User's credentials are correct
              ///get the email for Admin
              String verifyAdminEmailForAuth = await FireStoreService()
                  .verifyEmailAddressWithCustomerNumberForAdmin(customerNumber!);

              ///get the email for SubUser
              String verifySubUserEmailForAuth = await FireStoreService()
                  .verifyEmailAddressWithCustomerNumberForSubUser(customerNumber, email);

              ///check email for admin
              if (verifyAdminEmailForAuth == email) {
                ///email that is provided belongs to the Admin
                setState(() {
                  showLoading = false;
                });
                Navigator.pushReplacementNamed(
                  context,
                  FirstNavigation.routeName,
                  arguments: FirstNavigationArguments(
                    email: email,
                    isUserAdmin: true,
                    customerNumber: customerNumber,
                  ),
                );
              }

              ///check email for SubUser
              else if (verifySubUserEmailForAuth == email) {
                ///email that is provided belongs to the SubUser
                setState(() {
                  showLoading = false;
                });
                Navigator.pushReplacementNamed(
                  context,
                  FirstNavigation.routeName,
                  arguments: FirstNavigationArguments(
                    email: email,
                    isUserAdmin: false,
                    customerNumber: customerNumber,
                  ),
                );
              } else {
                ///email that is provided is wrong
                setState(() {
                  showLoading = false;
                  sp.remove("email");
                  sp.remove("customerNumber");
                  sp.remove("password");
                  sp.remove("primaryPassword");
                  passwordController.clear();
                });
                log.i("error");
                displayDialog();
              }
            } else {
              var sp = await SharedPreferences.getInstance();

              ///show error
              setState(() {
                showLoading = false;
                sp.remove("email");
                sp.remove("customerNumber");
                sp.remove("password");
                sp.remove("primaryPassword");
                passwordController.clear();
              });
              log.i("error");

              displayDialog();
            }
          }else{
            setState(() {
              showLoading = false;
            });
            displayDialog();
          }
        }

      } else {
        ///User's login info is not saved so we have to verify their info in order to log them in.

        if (_customerNumberKey.currentState!.validate() &&
            _emailKey.currentState!.validate() &&
            _passwordKey.currentState!.validate()) {
          ///Check if the textfields validators throw any error

          setState(() {
            showLoading = true;
          });

          ///Log user into Firebase Auth
          await AuthenticationService(_firebaseAuth).signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

          User? user = _firebaseAuth.currentUser;

          ///check if user credentials are correct
          if (user != null) {
            ///User's credentials are correct

            ///get the email for Admin
            String verifyAdminEmailForAuth = await FireStoreService()
                .verifyEmailAddressWithCustomerNumberForAdmin(
                    customerNumberController.text);

            ///get the email for SubUser
            String verifySubUserEmailForAuth = await FireStoreService()
                .verifyEmailAddressWithCustomerNumberForSubUser(
                    customerNumberController.text, emailController.text.trim());

            ///check email for admin
            if (verifyAdminEmailForAuth == emailController.text.trim()) {
              ///email that is provided belongs to the Admin

              ///get Admin phoneNumber
              String? getPhoneNumber =
              await FireStoreService().verifyPhoneNumberForAdmin(
                customerNumberController.text,
                emailController.text.trim(),
              );

              ///generate 6 digit code
              String codeSent = generateCustomerNumber();
              log.i(codeSent);
              log.i(getPhoneNumber);
              ///send code to the SubUser's phone
              var checkResponse = await WsdlRequest().sendSmsToUser(getPhoneNumber, codeSent);
              log.i(checkResponse);
              ///Navigate SubUser to the enter code page
              setState(() {
                showLoading = false;
              });
              Navigator.pushNamed(
                context,
                EnterCodeValidationPage.routeName,
                arguments: EnterCodeValidationPageArguments(
                    isUserAdmin: true,
                    phoneNumber: getPhoneNumber,
                    checkedValue: checkedValue,
                    codeSent: codeSent,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    customerNumber: customerNumberController.text),
              );
            }

            ///check email for SubUser
            else if (verifySubUserEmailForAuth == emailController.text.trim()) {
              ///email that is provided belongs to the SubUser

              ///get SubUser phoneNumber
              String? getPhoneNumber =
                  await FireStoreService().verifyPhoneNumberForSubUser(
                customerNumberController.text,
                emailController.text.trim(),
              );

              ///we must check if subuser has a valid phoneNumber stored
              if (getPhoneNumber == "-") {
                setState(() {
                  showLoading = false;
                });
                ///we will navigate subUser to enter a new phone number page
                Navigator.pushNamed(
                  context,
                  EnterPhoneNumberToValidate.routeName,
                  arguments: EnterPhoneNumberToValidateArguments(
                    checkedValue: checkedValue,
                    email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      customerNumber: customerNumberController.text,
                      isUserAdmin: false,
                  ),
                );
              } else {
                ///generate 6 digit code
                String codeSent = generateCustomerNumber();

                log.i(codeSent);
                ///send code to the SubUser's phone
                await WsdlRequest().sendSmsToUser(getPhoneNumber, codeSent);
                setState(() {
                  showLoading = false;
                });
                ///Navigate SubUser to the enter code page
                Navigator.pushNamed(
                  context,
                  EnterCodeValidationPage.routeName,
                  arguments: EnterCodeValidationPageArguments(
                      isUserAdmin: false,
                      checkedValue: checkedValue,
                      codeSent: codeSent,
                      phoneNumber: getPhoneNumber,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      customerNumber: customerNumberController.text),
                );
              }
            } else {
              ///email that is provided is wrong
              setState(() {
                showLoading = false;
              });
              log.i("error");
              log.i(verifySubUserEmailForAuth);

              displayDialog();
            }
          } else {
            ///show error
            setState(() {
              showLoading = false;
            });
            log.i("error");

            displayDialog();
          }
        }
      }
    } catch (e) {
      setState(() {
        showLoading = false;
      });
      log.i(e.toString());
      log.i("error");

      displayDialog();
    }
  }

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryWightColor,
        body: Stack(
          children: <Widget>[
            BackgroundALetter(),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildLogoHeader(),
                  buildSignInHeader(),
                  buildStateOfPage(),
                  NavigatorButton(
                    textLabel: "Giriş Yap",
                    onTap: onClickContinueDemo,
                    showLoading: showLoading,
                  ),
                  buildForgetRows(),
                  AlreadyHaveAccountRowCP(
                    secondText: "Kayıt ol",
                    onClickLogIn: onClickSignUp,
                    firstText: "Hesabın yok mu?",
                    fontSize: 11,
                  ),
                  StraightLine(),
                  buildContactUsRow(),
                  buildVersionText()
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  FutureBuilder buildStateOfPage() {
    return FutureBuilder(
      future: getStateOfPage(),
      builder: (context, snapshot) {
        return snapshot.data;
      },
    );
  }

  Future getStateOfPage() async {
    var sp = await SharedPreferences.getInstance();
    if (sp.containsKey("customerNumber") &&
        sp.containsKey("email") &&
        sp.containsKey("password")) {
      return buildAlreadyLoggedInState();
    } else {
      return buildLogInState();
    }
  }

  final _storage = FirebaseStorage.instance;

  Future<List> checkProfilePhoto() async {
    var sp = await SharedPreferences.getInstance();
    String? email = sp.getString("email");
    String? customerNumber = sp.getString("customerNumber");
    List list = [];
    try {
      var snapshot = await _storage
          .ref()
          .child("ProfilePhoto/" + customerNumber! + "/" + email!)
          .getDownloadURL();
      list.addAll([
        {"state": "true", "snap": snapshot}
      ]);
      return list;
    } catch (e) {
      log.i(e.toString());
      list.addAll([
        {"state": "false", "snap": "svg/user_header.svg"}
      ]);
      return list;
    }
  }

  Column buildAlreadyLoggedInState() {
    return Column(
      children: [
        FutureBuilder<List>(
          future: checkProfilePhoto(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                {
                  return Container(
                      width: 19.32.w,
                      height: 10.86.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: SvgPicture.asset(
                        "svg/user_header.svg",
                      ),);
                }
              case ConnectionState.active:
                {
                  return Container(
                      width: 19.32.w,
                      height: 10.86.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: SvgPicture.asset(
                        "svg/user_header.svg",
                      ));
                }
              case ConnectionState.done:
                {
                  return Container(
                      width: 19.32.w,
                      height: 10.86.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: snapshot.data![0]["state"] == "true"
                          ? CircleAvatar(
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                snapshot.data![0]["snap"]!,
                              ),
                            )
                          : SvgPicture.asset(
                              "svg/user_header.svg",
                            ),);
                }
              default:
                {
                  if (snapshot.hasData) {
                    return Container(
                        width: 12.80.w,
                        height: 7.20.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        child: snapshot.data![0]["state"] == "true"
                            ? CircleAvatar(
                                foregroundColor: Colors.transparent,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  snapshot.data![0]["snap"]!,
                                ),
                              )
                            : SvgPicture.asset(
                                "svg/user_header.svg",
                              ));
                  } else {
                    return SvgPicture.asset("svg/user_header.svg");
                  }
                }
            }
          },
        ),
        SizedBox(
          height: 2.5.h,
        ),
        Container(
          height: 3.h,
          child: Text(
            "İleka Akademi A.Ş.".toUpperCase(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: LocalHelper.getFontSize(13),
              color: AppColors.textPrimaryColor,
            ),
          ),
        ),
        buildPasswordFieldx(),
        Padding(
          padding: EdgeInsets.only(right: 7.72.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () async {
                var sp = await SharedPreferences.getInstance();
                setState(() {
                  sp.remove("email");
                  sp.remove("customerNumber");
                  sp.remove("password");
                  sp.remove("primaryPassword");
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: 25.w,
                child: Text(
                  "Sıfırla/Kaldır",
                  style: TextStyle(
                      fontSize: LocalHelper.getFontSize(13),
                      color: AppColors.infoContentDialogColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.5.h,
        ),
      ],
    );
  }

  Padding buildPasswordFieldx() {
    return Padding(
      padding:
          EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.h, top: 1.h),
      child: Form(
        key: _passwordKey,
        child: SixDigitNumberForm(
          isObscure: true,
          confirmController: passwordController,
          hintText: "Şifre",
          controller: passwordController,
        ),
      ),
    );
  }

  Column buildLogInState() {
    return Column(
      children: [
        buildCustomerNumberField(),
        buildEmailField(),
        buildPasswordField(),
        buildRememberMe(),
      ],
    );
  }

  Padding buildCustomerNumberField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.57.h),
      child: Form(
        key: _customerNumberKey,
        child: CustomCustomerNumberFormNew(
          controller: customerNumberController,
        ),
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(left: 7.72.w, right: 7.72.w, bottom: 2.71.h),
      child: Form(
          key: _emailKey,
          child: CustomEmailFormNew(
            controller: emailController,
          )),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 7.72.w,
        right: 7.72.w,
      ),
      child: Form(
        key: _passwordKey,
        child: CustomPasswordFormNew(
          hintText: "Şifre",
          controller: passwordController,
        ),
      ),
    );
  }

  CheckboxListTile buildRememberMe() {
    return CheckboxListTile(
      checkColor: AppColors.primaryWightColor,
      activeColor: AppColors.SignInColorGradientStart,
      title: Text("Beni hatırla"),
      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Padding buildLogoHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 9.h,
        bottom: 1.5.h,
      ),
      child: Container(
          height: 7.h,
          width: 60.w,
          child: Image.asset("assets/ileka_header_ex.png")),
    );
  }

  Padding buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Center(
        child: Text(
          'Giriş yap',
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

  Row buildContactUsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressedPhoneIcon,
          icon: Icon(
            Icons.phone,
            color: AppColors.phoneColor,
          ),
        ),
        Text(
          'İletişim Merkezi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: const Color(0xff6f6f6f),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Center buildVersionText() {
    return Center(
      child: Text(
        "İleka Ekstre 1.0.0",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(10),
          color: const Color(0xff7b7b7b),
        ),
      ),
    );
  }

  Padding buildForgetRows() {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.44.h,
        right: 7.72.w,
        left: 7.72.w,
        bottom: 8.02.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildForgetCustomerRow(),
          buildForgetPasswordRow(),
        ],
      ),
    );
  }

  InkWell buildForgetCustomerRow() {
    return InkWell(
      onTap: onClickForgetCustomerNumber,
      child: Text(
        'Müşteri numaramı unuttum',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          color: const Color(0xff7b7b7b),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  InkWell buildForgetPasswordRow() {
    return InkWell(
      onTap: onClickForgetPassword,
      child: Text(
        'Şifremi unuttum',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(11),
          color: const Color(0xffdb2820),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
