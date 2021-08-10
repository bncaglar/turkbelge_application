import 'package:flutter/material.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/screens/homepage_screens/homepage_screen.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/first_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/initial_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/creating_profile/second_step_of_registration.dart';
import 'package:turkbelge_application/screens/registration_screens/forget_screens/forget_customer_number.dart';
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

      case HomePage.routeName:
        {
          child = HomePage();
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
          child = FirstNavigation();
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
}
