import 'package:flutter/material.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class BuildLogo extends StatefulWidget {
  final String logoPath;
  final double height;
  final double width;
  final rightPadding;

  BuildLogo({
    required this.logoPath,
    required this.height,
    required this.width,
    required this.rightPadding,
  });

  @override
  _BuildLogoState createState() => _BuildLogoState();
}

class _BuildLogoState extends State<BuildLogo> {
  @override
  Widget build(BuildContext context) {
    return buildLogo(
        widget.logoPath, widget.height, widget.width, widget.rightPadding);
  }

  Padding buildLogo(
      String logoPath, double height, double width, double rightPadding) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Container(
          height: height,
          width: width,
          child: ImageIcon(
            AssetImage(
              logoPath,
            ),
            color: AppColors.icon_color,
          )),
    );
  }
}
