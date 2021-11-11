import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/l10n/ln10.dart';
import 'package:turkbelge_application/logic/AccountAndTransaction/account_and_transaction_cubit.dart';
import 'package:turkbelge_application/logic/account_sm/account_cubit.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/logic/filter_sm/filter_sm_cubit.dart';
import 'package:turkbelge_application/logic/groupCompany_sm/group_company_sm_cubit.dart';
import 'package:turkbelge_application/routes.dart';
import 'package:turkbelge_application/screens/registration_screens/SignInScreen_renewed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ChartSmCubit>(
              create: (BuildContext context) => ChartSmCubit(),
            ),
            BlocProvider<CurrencySmCubit>(
              create: (BuildContext context) => CurrencySmCubit(),
            ),
            BlocProvider<FilterSmCubit>(
              create: (BuildContext context) => FilterSmCubit(),
            ),
            BlocProvider<AccountCubit>(
              create: (BuildContext context) => AccountCubit(),
            ),
            BlocProvider<AccountAndTransactionCubit>(
              create: (BuildContext context) => AccountAndTransactionCubit(),
            ),
            BlocProvider<GroupCompanySmCubit>(
              create: (BuildContext context) => GroupCompanySmCubit(),
            ),
            BlocProvider<DropdownCubit>(
              create: (BuildContext context) => DropdownCubit(),
            ),
          ],
          child: GetMaterialApp(
            onGenerateRoute: Routes.generateRoute,
            title: 'İlekaekstre',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: _handleAuth(),
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

// class Authenticate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool?>(
//       future: checkInternetConnection(),
//       builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
//         if (snapshot.data == false) {
//           return NoInternetConnectionPage();
//         } else {
//           return Scaffold(
//             body: FutureBuilder<bool?>(
//               future: getBoolValuesSF(),
//               builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
//                 if (snapshot.data == false) {
//                   return SignInPage();
//                 } else {
//                   return _handleAuth();
//                 }
//               },
//             ),
//           );
//         }
//       },
//     );
//   }
//

Widget _handleAuth() {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (user != null) {
          signOut();
          return SignInPageRenewed();
        } else {
          return SignInPageRenewed();
        }
      } else {
        return SignInPageRenewed();
      }
    },
  ); // StreamBuilder
}

void signOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signOut();
}
//
//   Future<bool?> getBoolValuesSF() async {
//     SharedPreferences loginCheck = await SharedPreferences.getInstance();
//     return loginCheck.getBool("state");
//   }
//
//   Future<bool?> checkInternetConnection() async {
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//   }
// }
