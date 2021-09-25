import 'package:flutter/material.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/bank_details/bank_details_page.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/bank_details/bank_details_tab_controller.dart';
import 'package:turkbelge_application/screens/noInternetConnectionPage.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/first_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/initial_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/second_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_phone_auth.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number/forget_customer_number_verified_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_password/enter_new_password_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_password/forget_password_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';

import 'logger/simple_log_printer.dart';

final log = getLogger();

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log.i(
        "settings.name : ${settings.name}  | ScreenArguments: ${settings.arguments} ");

    Widget child;
    switch (settings.name) {
      case SignInPage.routeName:
        {
          child = SignInPage();
          break;
        }

      case InitialStepOfRegistration.routeName:
        {
          child = InitialStepOfRegistration();
          break;
        }
      case ForgetPasswordPage.routeName:
        {
          child = ForgetPasswordPage();
          break;
        }
      case ForgetCustomerNumberPage.routeName:
        {
          child = ForgetCustomerNumberPage();
          break;
        }
      case FirstStepOfRegistration.routeName:
        {
          child = _buildFirstStepRegistrationRoute(
              settings.arguments as FirstStepOfRegistrationArguments);
          break;
        }
      case SecondStepOfRegistration.routeName:
        {
          child = _buildEnterCodePageRoute(
              settings.arguments as SecondStepOfRegistrationArguments);
          break;
        }
      case EnterNewPasswordScreen.routeName:
        {
          child = EnterNewPasswordScreen();
          break;
        }
      case FirstNavigation.routeName:
        {
          child = _buildFirstNavigationRoutes(
              settings.arguments as FirstNavigationArguments);
          break;
        }
      case ForgetCustomerNumberPhoneAuth.routeName:
        {
          child = _buildForgetCustomerNumberPhoneAuthRoutes(
              settings.arguments as ForgetCustomerNumberPhoneAuthArguments);
          break;
        }
      case ForgetCustomerNumberVerifiedPage.routeName:
        {
          child = _buildForgetCustomerNumberVerifiedPageRoutes(
              settings.arguments as ForgetCustomerNumberVerifiedPageArguments);
          break;
        }
      case BankDetailsPage.routeName:
        {
          child = _buildBankDetailsPageRoutes(
              settings.arguments as BankDetailsPageArguments);
          break;
        }
      case BankDetailsOfTabController.routeName:
        {
          child = _buildBankDetailsOfTabControllerRoutes(
              settings.arguments as BankDetailsTabControllerArguments);
          break;
        }
      case NoInternetConnectionPage.routeName:
        {
          child = NoInternetConnectionPage();
          break;
        }
      default:
        child = Scaffold(
          body: Center(
            child: Text('No Route founded for : ${settings.name}'),
          ),
        );
        break;
    }

    return MaterialPageRoute(
        settings: settings, builder: (_) => applyFixedScaleFactor(child));
  }

  static Widget applyFixedScaleFactor(Widget child) {
    return Builder(builder: (BuildContext context) {
      final MediaQueryData data = MediaQuery.of(context);
      return MediaQuery(
        data: data.copyWith(textScaleFactor: 1),
        child: child,
      );
    });
  }

  static Widget _buildFirstStepRegistrationRoute(
      FirstStepOfRegistrationArguments arguments) {
    String? userName = arguments.userName;
    String? userEmail = arguments.userEmail;
    String? userPassword = arguments.userPassword;
    return FirstStepOfRegistration(
        userEmail: userEmail, userName: userName, userPassword: userPassword);
  }

  // static Widget _buidlHomePageRoute(
  //     HomePageArguments arguments
  //     ){
  //   String? getCurrency = arguments.getCurrency;
  //   String? customerNumber = arguments.customerNumber;
  //   return HomePage(getCurrency: getCurrency, customerNumber: customerNumber);
  // }
  static Widget _buildEnterCodePageRoute(
      SecondStepOfRegistrationArguments arguments) {
    String? userName = arguments.userName;
    String? userEmail = arguments.userEmail;
    String? userPassword = arguments.userPassword;
    String? userCustomerNumber = arguments.userCustomerNumber;
    String? userTCKN = arguments.userTCKN;
    String? userVKN = arguments.userVKN;
    String? userPhoneNumber = arguments.userPhoneNumber;
    return SecondStepOfRegistration(
        userPassword: userPassword,
        userEmail: userEmail,
        userName: userName,
        userCustomerNumber: userCustomerNumber,
        userPhoneNumber: userPhoneNumber,
        userTCKN: userTCKN,
        userVKN: userVKN);
  }

  static Widget _buildFirstNavigationRoutes(
      FirstNavigationArguments arguments) {
    String? customerNumber = arguments.customerNumber;
    return FirstNavigation(customerNumber: customerNumber!);
  }

  static Widget _buildForgetCustomerNumberPhoneAuthRoutes(
      ForgetCustomerNumberPhoneAuthArguments arguments) {
    String? tcknOrVknNumber = arguments.tcknOrVknNumber;
    String? userEmail = arguments.userEmail;
    String? userPassword = arguments.userPassword;
    return ForgetCustomerNumberPhoneAuth(
        tcknOrVknNumber: tcknOrVknNumber,
        userEmail: userEmail,
        userPassword: userPassword);
  }

  static Widget _buildForgetCustomerNumberVerifiedPageRoutes(
      ForgetCustomerNumberVerifiedPageArguments arguments) {
    String? userEmail = arguments.userEmail;
    return ForgetCustomerNumberVerifiedPage(
      userEmail: userEmail,
    );
  }

  static Widget _buildBankDetailsPageRoutes(
      BankDetailsPageArguments arguments) {
    String? bankName = arguments.bankName;
    String? bankAccountKey = arguments.bankAccountKey;
    String? bankIcon = arguments.bankIcon;
    BoxFit? fitt = arguments.fitt;
    return BankDetailsPage(
      bankAccountKey: bankAccountKey,
      bankIcon: bankIcon,
      bankName: bankName,
      fitt: fitt,
    );
  }

  static Widget _buildBankDetailsOfTabControllerRoutes(
      BankDetailsTabControllerArguments arguments) {
    String? bankName = arguments.bankName;
    String? bankAccountKey = arguments.bankAccountKey;
    String? bankIcon = arguments.bankIcon;
    BoxFit? fitt = arguments.fitt;
    return BankDetailsOfTabController(
      bankCode: bankAccountKey,
      bankIcon: bankIcon,
      bankName: bankName,
      fit: fitt,
    );
  }
}
