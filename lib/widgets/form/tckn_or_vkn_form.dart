import 'package:flutter/material.dart';
import 'package:turkbelge_application/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TcknOrVknForm extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final VoidCallback? onEditingComplete;
  String? inputChangedValue;

  TcknOrVknForm({required this.labelText, required this.controller, this.onEditingComplete, this.inputChangedValue});

  @override
  _TcknOrVknFormState createState() => _TcknOrVknFormState();
}

class _TcknOrVknFormState extends State<TcknOrVknForm> {
  String? tcknOrVknValidator(String? value){
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length == 0) {
      return appLocalizations.required;
    }else if(value.length !=11 && value.length != 10){
      return appLocalizations.addProperTcknOrVknValue;
    }

  }
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      onInputChangedValue: widget.inputChangedValue,
      inputFormatters: 11,
      validator: tcknOrVknValidator,
      labelText: widget.labelText,
      controller: widget.controller,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      onEditingComplete: widget.onEditingComplete,
    );
  }
}
