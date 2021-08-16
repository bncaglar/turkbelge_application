import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/utilities/colors.dart';

import 'custom_text_field.dart';

class SearchChallengesField extends StatefulWidget {
  final String? serverSearchErrorText;
  final TextEditingController controller;
  final String? addSearchFieldTitle;
  final VoidCallback? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTapSuffixIcon;

  SearchChallengesField({
    required this.onTapSuffixIcon,
    required this.controller,
    this.serverSearchErrorText,
    this.addSearchFieldTitle,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  _SearchChallengesFieldState createState() => _SearchChallengesFieldState();
}

class _SearchChallengesFieldState extends State<SearchChallengesField> {
  final log = Logger();

  onArrowClicked() {
    log.i("onArrowClicked Started");
  }

  onClickSearchIcon() {
    log.i("onClickSearchIcon started");
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: widget.addSearchFieldTitle ?? "Arama yap",
      controller: widget.controller,
      onEditingComplete: widget.onEditingComplete,
      fromRegistration: false,
      suffixIcon:
          InkWell(onTap: widget.onTapSuffixIcon, child: Icon(Icons.close)),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.text,
      onChanged: widget.onChanged,
    );
  }
}
