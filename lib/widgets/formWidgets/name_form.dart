import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'buildLogo.dart';
import 'buildTextFormField.dart';

class CustomNameFormNew extends StatefulWidget {
  final TextEditingController controller;

  CustomNameFormNew({required this.controller});

  @override
  _CustomNameFormNewState createState() => _CustomNameFormNewState();
}

class _CustomNameFormNewState extends State<CustomNameFormNew> {
  String? nameValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    if (value!.length <= 2) {
      return appLocalizations.nameShouldBeAtLeast3Char;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.name,
      prefixIcon: BuildLogo(
          logoPath: "assets/user.png",
          height: 2.98.h,
          width: 3.98.w,
          rightPadding: 4.95.w),
      hintText: "Adınız Soyadınız",
      isObscureText: false,
      validator: nameValidator,
      maxlength: 6,
    );
  }
}
