import 'package:flutter/material.dart';
import 'package:turkbelge_application/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerNumberForm extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  CustomerNumberForm({required this.controller, required this.labelText});

  @override
  _CustomerNumberFormState createState() => _CustomerNumberFormState();
}

class _CustomerNumberFormState extends State<CustomerNumberForm> {
  String? customerNumberValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    if (value.toString().length <= 5) {
      return appLocalizations.customerNumberValidatorText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      inputFormatters: 6,
        validator: customerNumberValidator,
        controller: widget.controller,
        labelText: widget.labelText,
        keyboardType: TextInputType.number,
        autoValidateMode: AutovalidateMode.onUserInteraction);
  }
}
