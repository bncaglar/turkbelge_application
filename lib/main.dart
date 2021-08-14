import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:turkbelge_application/bottom_navigation_bar/first_navigation.dart';
import 'package:turkbelge_application/l10n/ln10.dart';
import 'package:turkbelge_application/routes.dart';
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
            home: SignInPage(),
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
    final firebaseUser = context.watch<User>();
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData || firebaseUser != null) {
              return FirstNavigation();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Bir şeyler yanlış gitti!"),
              );
            } else {
              return SignInPage();
            }
          }),
    );
  }
}
