import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/l10n/ln10.dart';
import 'package:turkbelge_application/routes.dart';
import 'package:turkbelge_application/screens/gyu.dart';
import 'package:turkbelge_application/screens/registration_screens/signin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'logic/firebase_auth/firebase_state_management_cubit.dart';

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
    return Sizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<FirebaseStateManagementCubit>(
              create: (BuildContext context) => FirebaseStateManagementCubit()),

        ],
        child: MaterialApp(
          onGenerateRoute: Routes.generateRoute,
          title: 'Türk Belge',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthenticationWrapper(),
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      );
    });
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseStateManagementCubit,
        FirebaseStateManagementState>(builder: (context, state) {
      if (state is FirebaseUnAuthorized) {
        return SignInPage();
      }
      if (state is FirebaseAuthorized) {
        return ExamplePage();
      }
      return Container();
    });
  }
}
