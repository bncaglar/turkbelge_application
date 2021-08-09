import 'package:flutter/material.dart';
import 'package:turkbelge_application/constants/strings.dart';

import '../custom_text_field.dart';

class EmailForm extends StatefulWidget {
  final String? serverEmailErrorText;
  final TextEditingController controller;
  final String labelText;

  EmailForm({
    required this.controller,
    this.serverEmailErrorText,
    required this.labelText
  });

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  String? emailValidator(String? value) {
    String pattern = Strings.P_EMAIL_PATTERN;
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(value!.trim())) {
      return widget.serverEmailErrorText ?? "Geçersiz e-posta";
    }
    return widget.serverEmailErrorText;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
        validator: emailValidator,
        labelText: widget.labelText,
        controller: widget.controller,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress);
  }
}