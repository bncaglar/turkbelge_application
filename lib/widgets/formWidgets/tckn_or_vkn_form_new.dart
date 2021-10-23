import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import 'buildLogo.dart';
import 'buildTextFormField.dart';

class TCKNVKNFormNew extends StatefulWidget {
  final TextEditingController controller;

  TCKNVKNFormNew({required this.controller});

  @override
  _TCKNVKNFormNewState createState() => _TCKNVKNFormNewState();
}

class _TCKNVKNFormNewState extends State<TCKNVKNFormNew> {
  String? tcknOrVknValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length == 0) {
      return appLocalizations.required;
    } else if (value.length != 11 && value.length != 10) {
      return appLocalizations.addProperTcknOrVknValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      prefixIcon: BuildLogo(
          logoPath: "svg/user.svg",
          height: 2.98.h,
          width: 3.98.w,
          rightPadding: 4.95.w),
      hintText: "Vergi veya Kimlik Numaranız",
      isObscureText: false,
      validator: tcknOrVknValidator,
      maxlength: 11,
    );
  }
}
