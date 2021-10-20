import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IconBtnAsPngImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? boxFit;

  const IconBtnAsPngImage({
    required this.imageUrl,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.75.h,
      width: 6.66.w,
      child: Image.asset(
        imageUrl,
        fit: boxFit ?? BoxFit.contain,
      ),
    );
  }
}
