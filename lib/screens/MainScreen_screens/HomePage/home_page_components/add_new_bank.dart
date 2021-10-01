import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class AddNewBankPage extends StatefulWidget {
  static const routeName = '/AddNewBankPage';
  const AddNewBankPage({Key? key}) : super(key: key);

  @override
  _AddNewBankPageState createState() => _AddNewBankPageState();
}

class _AddNewBankPageState extends State<AddNewBankPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(),
      ),
    );
  }

  Container buildBody() {
    return Container();
  }
}
