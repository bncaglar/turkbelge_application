import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/l10n/ln10.dart';
import 'package:turkbelge_application/routes.dart';
import 'package:turkbelge_application/screens/noInternetConnectionPage.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance),
            ),
            StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges,
              initialData: null,
            ),
          ],
          child: MaterialApp(
            onGenerateRoute: Routes.generateRoute,
            title: 'Türk Belge',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Authenticate(),
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: checkInternetConnection(),
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.data == false) {
          return NoInternetConnectionPage();
        } else {
          return Scaffold(
            body: FutureBuilder<bool?>(
              future: getBoolValuesSF(),
              builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                if (snapshot.data == false) {
                  return SignInPage();
                } else {
                  return _handleAuth();
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _handleAuth() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        return (!snapshot.hasData) ? SignInPage() : FirstNavigation();
      },
    ); // StreamBuilder
  }

  Future<bool?> getBoolValuesSF() async {
    SharedPreferences loginCheck = await SharedPreferences.getInstance();
    return loginCheck.getBool("state");
  }

  Future<bool?> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
