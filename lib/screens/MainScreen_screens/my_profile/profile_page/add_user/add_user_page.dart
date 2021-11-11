import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/formWidgets/email_form.dart';
import 'package:turkbelge_application/widgets/formWidgets/password_form.dart';

import 'add_user_header.dart';
import 'add_user_middle.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = '/AddUserScreen';

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  bool ziraatValue = false;
  bool garantiValue = false;
  bool vakifValue = false;
  bool sekerbank = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildBody(),
      ),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: EdgeInsets.only(
        right: 7.72.w,
        left: 7.72.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddUserHeaderPart(),
          AddUserPageMiddlePart(),
          buildEachRow(ziraatValue)
        ],
      ),
    );
  }

  Padding buildEachRow(value) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 2.05.h,
      ),
      child: Container(
        height: 3.326.h,
        child: Row(
          children: [
            buildCheckBoxVerified(value),
          ],
        ),
      ),
    );
  }
  void _onRememberMeChanged(bool? newValue) => setState(() {
    ziraatValue = newValue!;

    if (ziraatValue) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });

  Container buildCheckBoxVerified(bool value) {
    return Container(
      height: 3.26.h,
      width: 5.79.w,
      child: Checkbox(
        checkColor: Colors.white,
          activeColor: AppColors.SignInColorGradientStart,
          value: value,
        onChanged: _onRememberMeChanged
      ),
    );
  }
}
