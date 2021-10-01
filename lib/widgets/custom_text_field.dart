import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';

class CustomTextFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final AutovalidateMode autoValidateMode;
  final String? labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? fromRegistration;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onEditingComplete;
  final TextStyle? style;
  final InputDecoration? decoration;
  final VoidCallback? onChanged;
  final int? inputFormatters;
  String? onInputChangedValue;
  TextEditingController? tcknOrVknController;
  String? userVknNumber;

  CustomTextFormField(
      {this.validator,
      this.autoValidateMode = AutovalidateMode.disabled,
      required this.controller,
      required this.labelText,
      this.obscureText = false,
      this.fromRegistration = true,
      this.keyboardType,
      this.suffixIcon,
      this.onEditingComplete,
      this.style,
      this.decoration,
      this.prefixIcon,
      this.onChanged,
      this.inputFormatters,
      this.onInputChangedValue,
      this.tcknOrVknController,
      this.userVknNumber});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.inputFormatters ?? 55),
      ],
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText ?? false,
      validator: widget.validator,
      onChanged: (text) {
        // if (widget.tcknOrVknController!.text.length == 10) {
        //   setState(() {
        //     widget.userVknNumber = text;
        //     print("vkn");
        //     print(widget.userVknNumber);
        //   });
        // } else if (widget.tcknOrVknController!.text.length == 11) {
        //   setState(() {
        //     widget.userTcknNumber = text;
        //     print("tckn");
        //     print(widget.userTcknNumber);
        //   });
        // }
        // setState(() {
        //   widget.onInputChangedValue = text;
        //   print(widget.onInputChangedValue);
        // });
      },
      autovalidateMode: widget.autoValidateMode,
      textAlignVertical: TextAlignVertical.center,
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onChanged,
      style: widget.style ??
          TextStyle(
            fontSize: widget.fromRegistration! ? 16 : 15,
            fontStyle: FontStyle.normal,
            fontFamily: "absolute",
            color: AppColors.textPrimaryColor,
          ),
      decoration: widget.decoration ??
          (widget.fromRegistration!
              ? buildInputDecorationForRegistrationScreens()
              : buildDefaultInputDecoration()),
    );
  }

  InputDecoration buildInputDecorationForRegistrationScreens() {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: AppColors.primaryGreyColor,
      labelText: widget.labelText,
      focusColor: AppColors.primaryColor,
      prefixIcon: widget.prefixIcon ?? null,
      suffixIcon: widget.suffixIcon ?? null,
      errorStyle: TextStyle(
        fontSize: 8.57.sp,
      ),
      contentPadding: EdgeInsets.only(
        left: 1.7.w,
        bottom: 4.w,
      ),
      hintStyle: TextStyle(
        fontSize: LocalHelper.getFontSize(16),
        fontStyle: FontStyle.normal,
        fontFamily: "absolute",
        color: AppColors.textPrimaryColor,
      ),
      labelStyle: TextStyle(
        fontSize: LocalHelper.getFontSize(16),
        fontStyle: FontStyle.normal,
        fontFamily: "absolute",
        color: AppColors.textPrimaryColor,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.errorColor,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.errorColor,
        ),
      ),
    );
  }

  InputDecoration buildDefaultInputDecoration() {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: AppColors.homepageTextColor,
      labelText: widget.labelText,
      focusColor: AppColors.primaryColor,
      prefixIcon: widget.prefixIcon ?? null,
      suffixIcon: widget.suffixIcon ?? null,
      errorStyle: TextStyle(
        fontSize: LocalHelper.getFontSize(8),
      ),
      contentPadding: EdgeInsets.only(
        left: 1.7.w,
        bottom: 4.w,
      ),
      hintStyle: TextStyle(
        fontSize: LocalHelper.getFontSize(15),
        fontStyle: FontStyle.normal,
        fontFamily: "absolute",
        color: AppColors.textPrimaryColor,
      ),
      labelStyle: TextStyle(
        fontSize: LocalHelper.getFontSize(15),
        fontStyle: FontStyle.normal,
        fontFamily: "absolute",
        color: AppColors.textPrimaryColor,
      ),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }
}
