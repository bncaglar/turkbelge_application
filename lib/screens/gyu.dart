import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/logic/firebase_auth/firebase_state_management_cubit.dart';
import 'package:turkbelge_application/services/authentication_service.dart';

class ExamplePage extends StatefulWidget {
  static const routeName = '/ExamplePage';

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final log = getLogger();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  onClickLogOut() async {
    await AuthenticationService(_firebaseAuth).logOut();
    if (_firebaseAuth.currentUser == null) {
      context
          .read<FirebaseStateManagementCubit>()
          .changeAuthenticationState(FirebaseUnAuthorized());
      log.i("Çıkış başarılı! :-)))");
    } else {
      log.i("Çıkış başarısız");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Giriş Başarılı",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Container(
            height: 50,
          ),
          GestureDetector(
            onTap: () async {
              onClickLogOut();
            },
            child: Container(
              height: 75,
              width: 150,
              color: Colors.black,
              child: Center(
                child: Text(
                  "Çıkış yap",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
