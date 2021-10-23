import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/constants/strings.dart';
import 'package:turkbelge_application/widgets/formWidgets/buildTextFormField.dart';

import 'buildLogo.dart';

class CustomEmailFormNew extends StatefulWidget {
  final TextEditingController controller;

  CustomEmailFormNew({
    required this.controller
});
  @override
  _CustomEmailFormNewState createState() => _CustomEmailFormNewState();
}

class _CustomEmailFormNewState extends State<CustomEmailFormNew> {


  String? emailValidator(String? value) {
    String pattern = Strings.P_EMAIL_PATTERN;
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(value!.trim())) {
      return "Geçersiz e-posta";
    }
  }
  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: BuildLogo(
         logoPath: "svg/envelope.svg", height: 2.72.h, width: 5.28.w,  rightPadding: 4.37.w,
      ),
      hintText: "E-posta",
      isObscureText: false,
      validator: emailValidator,
      maxlength: 55,
    );
  }
}
