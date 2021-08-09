import 'package:flutter/material.dart';
import 'package:turkbelge_application/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnterCodeForm extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final VoidCallback? onEditingComplete;

  EnterCodeForm({required this.controller, required this.labelText, this.onEditingComplete});

  @override
  _EnterCodeFormState createState() => _EnterCodeFormState();
}

class _EnterCodeFormState extends State<EnterCodeForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String? codeSentValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length != 6) {
      return appLocalizations.enterValidCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      inputFormatters: 6,
      validator: codeSentValidator,
      labelText: widget.labelText,
      controller: widget.controller,
      onChanged: widget.onEditingComplete,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
    );
  }
}
