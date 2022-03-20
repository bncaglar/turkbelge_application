import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'buildLogo.dart';
import 'buildTextFormField.dart';

class TransactionSearchForm extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onEditingComplete;
TransactionSearchForm({
    required this.controller,
  required this.onEditingComplete,
});
  @override
  _TransactionSearchFormState createState() => _TransactionSearchFormState();
}

class _TransactionSearchFormState extends State<TransactionSearchForm> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: false,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (value) {
      },
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: AppColors.textPrimaryColor)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: AppColors.textPrimaryColor)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: AppColors.textPrimaryColor)
        ),
        hintText: "Arama",
        prefixIcon: Icon(Icons.search_sharp, color: AppColors.textPrimaryColor,size: 20,),
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
