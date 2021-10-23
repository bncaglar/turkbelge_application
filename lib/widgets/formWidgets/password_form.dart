import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'buildLogo.dart';
import 'buildTextFormField.dart';


class CustomPasswordFormNew extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? confirmPasswordController;

  CustomPasswordFormNew({
    required this.controller,
    this.confirmPasswordController
});
  @override
  _CustomPasswordFormNewState createState() => _CustomPasswordFormNewState();
}

class _CustomPasswordFormNewState extends State<CustomPasswordFormNew> {
  String? passwordValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    if (value != null) {
      bool hasOneUpperCaseLetter = RegExp("(?=.*[A-Z])").hasMatch(value);
      bool hasOneNumber = RegExp(".*[0-9].*").hasMatch(value);
      bool hasOneSpecialCharacter = RegExp(".[`@#!%\$&^*()].*").hasMatch(value);

      if (value.length == 0) {
        return appLocalizations.required;
      } else if (value.length < 8) {
        return appLocalizations.passwordMinimumLength;
      } else if (!hasOneUpperCaseLetter) {
        return appLocalizations.passwordOneUppercase;
      } else if (!hasOneNumber) {
        return appLocalizations.passwordOneNumber;
      } else if (!hasOneSpecialCharacter) {
        return appLocalizations.passwordOneSpecialCharacter;
      }else if (widget.confirmPasswordController != null &&
          (widget.confirmPasswordController!.text != widget.controller.text)) {
        return appLocalizations.confirmationDoesNotMatch;
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.text,
      prefixIcon:
      BuildLogo(logoPath: "svg/key.svg", height: 3.26.h, width: 5.79.w, rightPadding: 4.34.w),
      hintText: "Şifre",
      isObscureText: true,
      validator: passwordValidator,
      maxlength: 55,
    );
  }
}
