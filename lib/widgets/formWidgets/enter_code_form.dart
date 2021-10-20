import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'buildTextFormField.dart';

class EnterCodeFormNew extends StatefulWidget {
  final TextEditingController controller;

  EnterCodeFormNew({required this.controller});

  @override
  _EnterCodeFormNerState createState() => _EnterCodeFormNerState();
}

class _EnterCodeFormNerState extends State<EnterCodeFormNew> {
  String? codeSentValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length != 6) {
      return appLocalizations.enterValidCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: false,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      hintText: "Kodu giriniz.",
      isObscureText: false,
      validator: codeSentValidator,
      maxlength: 6,
      prefixIcon: Container(),
    );
  }
}
