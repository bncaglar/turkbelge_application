import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'buildLogo.dart';
import 'buildTextFormField.dart';

class CustomCustomerNumberFormNew extends StatefulWidget {
  final TextEditingController controller;
  CustomCustomerNumberFormNew({
    required this.controller
});
  @override
  _CustomCustomerNumberFormNewState createState() => _CustomCustomerNumberFormNewState();
}

class _CustomCustomerNumberFormNewState extends State<CustomCustomerNumberFormNew> {
  String? customerNumberValidator(String? value) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    if (value.toString().length <= 5) {
      return appLocalizations.customerNumberValidatorText;
    }
  }
  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      prefixIcon:
      BuildLogo(logoPath: "assets/user.png", height: 2.98.h, width: 3.98.w, rightPadding: 4.95.w),
      hintText: "Müşteri Numarası",
      isObscureText: false,
      validator: customerNumberValidator,
      maxlength: 6,
    );
  }
}
