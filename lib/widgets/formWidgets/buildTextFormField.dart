import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class CustomTextFormFieldNew extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget prefixIcon;
  final String hintText;
  final bool isObscureText;
  final String? Function(String?)? validator;
  final int maxlength;
  final bool addPrefix;
  CustomTextFormFieldNew({
    required this.controller,
    required this.keyboardType,
     required this.prefixIcon,
    required this.addPrefix,
    required this.hintText,
    required this.isObscureText,
    required this.validator,
    required this.maxlength,
  });

  @override
  _CustomTextFormFieldNewState createState() => _CustomTextFormFieldNewState();
}

class _CustomTextFormFieldNewState extends State<CustomTextFormFieldNew> {
  bool showObscureText = true;

  @override
  Widget build(BuildContext context) {
    return buildTextFormField(
       widget.controller,
      widget.keyboardType,
      widget.prefixIcon,
      widget.hintText,
      widget.isObscureText,
      widget.validator,
      widget.maxlength,
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller,
      TextInputType keyboardType,
      Widget prefixIcon,
      String hintText,
      bool isObscureText,
      String? Function(String?)? validator,
      maxlength) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxlength),
      ],
      controller: controller,
      obscureText: isObscureText ? showObscureText : false,
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {});
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: isObscureText
            ? showObscureText
                ? InkWell(
                    onTap: () {
                      setState(() {
                        showObscureText = !showObscureText;
                      });
                    },
                    child: Icon(
                      Icons.visibility_off,
                      color: AppColors.icon_color,
                    ))
                : InkWell(
                    onTap: () {
                      setState(() {
                        showObscureText = !showObscureText;
                      });
                    },
                    child: Icon(
                      Icons.visibility,
                      color: AppColors.icon_color,
                    ),
                  )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFormUnderLineColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textFormUnderLineColor,
          ),
        ),
        hintText: hintText,
        prefixIcon: widget.addPrefix ? prefixIcon : null,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: LocalHelper.getFontSize(12),
          color: AppColors.textFormUnderLineColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
