import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/services/generator/randomCustomerNumberGenerator.dart';
import 'package:turkbelge_application/services/wsdl_request.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/backgroundALetter.dart';
import 'package:turkbelge_application/widgets/navigator_button.dart';

import 'enter_code_validation.dart';

class EnterPhoneNumberToValidate extends StatefulWidget {
  static const routeName = '/EnterPhoneNumberToValidate';
  final String email;
  final String password;
  final String customerNumber;
  final bool isUserAdmin;
  final bool checkedValue;

  EnterPhoneNumberToValidate({
    required this.email,
    required this.password,
    required this.customerNumber,
    required this.isUserAdmin,
    required this.checkedValue,
  });

  @override
  _EnterPhoneNumberToValidateState createState() =>
      _EnterPhoneNumberToValidateState();
}

class _EnterPhoneNumberToValidateState
    extends State<EnterPhoneNumberToValidate> {
  final log = Logger();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? phone;
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  bool showLoading = false;

  final TextEditingController controller = TextEditingController();

  onClickContinue() async {
    log.i("onClickContinue started");
    if (formKey.currentState!.validate()) {
      ///generate 6 digit code
      String codeSent = generateCustomerNumber();

      log.i(codeSent);
      ///send code to the SubUser's phone
      await WsdlRequest().sendSmsToUser(phone!, codeSent);

      ///Navigate SubUser to the enter code page
      Navigator.pushNamed(
        context,
        EnterCodeValidationPage.routeName,
        arguments: EnterCodeValidationPageArguments(
          isUserAdmin: widget.isUserAdmin,
          codeSent: codeSent,
          phoneNumber: phone!,
          checkedValue: widget.checkedValue,
          email: widget.email,
          password: widget.password,
          customerNumber: widget.customerNumber,
        ),
      );
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
        child: showFormState(),
      ),
    );
  }

  Column showFormState() {
    return Column(
      children: [
        buildSignInHeader(),
        buildSignInToAccountText(),
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
          'Telefon Numaranı Ekle',
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
          'Aktivasyonu tamamla',
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
      ),
    );
  }

  Padding buildDesc() {
    return Padding(
      padding: EdgeInsets.only(
        right: 6.w,
        left: 6.w,
      ),
      child: Text(
        "Telefon numaranı girdikten sonra gelen kodu girerek aktivasyonu tamamlayabilirsin.",
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

class EnterPhoneNumberToValidateArguments {
  final String email;
  final String password;
  final bool isUserAdmin;
  final bool checkedValue;
  final String customerNumber;

  EnterPhoneNumberToValidateArguments(
      {required this.email,
      required this.password,
      required this.customerNumber,
      required this.isUserAdmin,
      required this.checkedValue,
      });
}
