import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import '../custom_text_field.dart';

class PasswordForm extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? confirmPasswordController;
  final String labelText;
  final String? passwordServerError;

  PasswordForm(
      {required this.controller,
      this.confirmPasswordController,
      this.passwordServerError,
      required this.labelText});

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool isPasswordVisible = false;

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
      } else if (widget.confirmPasswordController != null &&
          (widget.confirmPasswordController!.text != widget.controller.text)) {
        return appLocalizations.confirmationDoesNotMatch;
      }
    }

    if (widget.passwordServerError != null) {
      return widget.passwordServerError;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      validator: passwordValidator,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPasswordVisible ? false : true,
      suffixIcon: IconButton(
        icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        color: AppColors.textPrimaryColor,
        onPressed: () {
          setState(
            () {
              isPasswordVisible = !isPasswordVisible;
            },
          );
        },
      ),
    );
  }
}
