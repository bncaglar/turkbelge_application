import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'buildLogo.dart';
import 'buildTextFormField.dart';

class SixDigitNumberForm extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController confirmController;
  final String hintText;
  final bool isObscure;
  SixDigitNumberForm({
    required this.isObscure,
    required this.controller,
    required this.hintText,
    required this.confirmController
});
  @override
  _SixDigitNumberFormState createState() => _SixDigitNumberFormState();
}

class _SixDigitNumberFormState extends State<SixDigitNumberForm> {
  String? sixDigitPasswordValidator(String? value){
    if(value.toString().length <= 5 ){
      return "Şifre 6 haneden büyük olmalıdır!";
    }else if(widget.confirmController != null &&
        (widget.confirmController.text != widget.controller.text)){
      return "Şifreler aynı olmalıdır!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFieldNew(
      addPrefix: true,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      prefixIcon:
      BuildLogo(logoPath: "svg/key.svg", height: 2.98.h, width: 3.98.w, rightPadding: 4.95.w),
      hintText: widget.hintText,
      isObscureText: widget.isObscure,
      validator: sixDigitPasswordValidator,
      maxlength: 6,
    );
  }
}
