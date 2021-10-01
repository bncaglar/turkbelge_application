import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class AddUserPage extends StatefulWidget {
  static const routeName = '/AddUserPage';

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
      ),
    );
  }
}
