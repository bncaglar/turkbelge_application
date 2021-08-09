import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom_text_field.dart';

class NameForm extends StatefulWidget {
  String? labelText;
  TextEditingController? controller;

  NameForm({required this.controller, required this.labelText});

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  String? nameValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length <= 2) {
      return appLocalizations.nameShouldBeAtLeast3Char;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
        validator: nameValidator,
        labelText: widget.labelText,
        controller: widget.controller,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.name);
  }
}
