import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class CustomAppBar extends StatefulWidget {
  final String? imagePath;
  final bool? isBankImageShown;
  final BoxFit? fitt;
  CustomAppBar(
      {required this.imagePath, required this.isBankImageShown, this.fitt});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final log = getLogger();
  onClickBackBtn() {
    log.i("onClickBackBtn started");
    Navigator.pop(context);
  }

  onClickSearchButton() {
    log.i("onClickSearchButton started");
  }

  @override
  Widget build(BuildContext context) {
    return buildAppBar();
  }

  Container buildAppBar() {
    return Container(
      width: double.infinity,
      height: 8.h,
      child: buildAppBarRow(),
      color: AppColors.homepageTextColor,
    );
  }

  Row buildAppBarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildAppBarRowRightSide(),
        buildSearchBtn(),
      ],
    );
  }

  Row buildAppBarRowRightSide() {
    return Row(
      children: [
        buildBackBtn(),
        widget.isBankImageShown! ? buildBankImage() : Container()
      ],
    );
  }

  IconButton buildSearchBtn() {
    return IconButton(
      onPressed: () {
        onClickSearchButton();
      },
      icon: Icon(
        Icons.search,
        color: AppColors.allNotificationsTextColor,
        size: 20.sp,
      ),
    );
  }

  IconButton buildBackBtn() {
    return IconButton(
      onPressed: () {
        onClickBackBtn();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: AppColors.backgroundPrimaryColor,
        size: 17.sp,
      ),
    );
  }

  Container buildBankImage() {
    return Container(
      padding: EdgeInsets.only(left: 3.w),
      height: 8.h,
      width: 30.w,
      child: Image.asset(
        widget.imagePath!,
        fit: widget.fitt ?? BoxFit.fitWidth,
      ),
    );
  }
}
