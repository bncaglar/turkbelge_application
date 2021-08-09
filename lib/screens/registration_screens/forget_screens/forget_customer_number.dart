import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/screens/registration_screens/registration_screen_components/registration_page_header.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/form/email_form.dart';
import 'package:turkbelge_application/widgets/form/tckn_or_vkn_form.dart';
import 'package:turkbelge_application/widgets/navigation_button.dart';

class ForgetCustomerNumberPage extends StatefulWidget {
  static const routeName = '/ForgetCustomerNumberPage';

  @override
  _ForgetCustomerNumberPageState createState() =>
      _ForgetCustomerNumberPageState();
}

class _ForgetCustomerNumberPageState extends State<ForgetCustomerNumberPage> {
  final log = getLogger();
  TextEditingController emailController = TextEditingController();
  TextEditingController tcknOrVknController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _tcknOrCknKey = GlobalKey<FormState>();

  onClickContinue() {
    log.i("onClickContinue started");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildForgetCustomerPageBody(),
      ),
    );
  }

  SingleChildScrollView buildForgetCustomerPageBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RegistrationPageHeader(
            addBackButton: true,
            subText: AppLocalizations.of(context).resetYourCustomerNumber,
            headerText: AppLocalizations.of(context).forgotMyCustomerNumber,
          ),
          buildTcknOrVkn(),
          buildEmailField(),
          buildResendButton(),
          enterYourCredentialsText()
        ],
      ),
    );
  }

  Padding buildTcknOrVkn() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.backgroundPrimaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Form(
          key: _tcknOrCknKey,
          child: TcknOrVknForm(
            controller: tcknOrVknController,
            labelText: AppLocalizations.of(context).tcknOrVkn,
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

  NavigationButton buildResendButton() {
    return NavigationButton(
      navigationButtonText: AppLocalizations.of(context).send,
      textColor: AppColors.backgroundPrimaryColor,
      onClickNavigatorButton: onClickContinue,
      margin: EdgeInsets.only(
        left: 4.69.w,
        right: 4.69.w,
        top: 4.754.h,
      ),
    );
  }

  Padding enterYourCredentialsText() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
      child: Container(
        width: double.infinity,
        height: 9.h,
        child: Center(
          child: Text(
            AppLocalizations.of(context).forgetCustomerNumberInfoText,
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
}
