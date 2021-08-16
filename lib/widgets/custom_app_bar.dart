import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:turkbelge_application/widgets/search_field.dart';

class CustomAppBar extends StatefulWidget {
  final String? imagePath;
  final BoxFit? fitt;
  final String? searchFieldTitle;
  final String? addSearchFieldTitle;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onChanged;
  final double? searchFieldHeight;
  final double? searchFieldWidth;

  CustomAppBar({
    this.imagePath,
    this.fitt,
    this.searchFieldTitle,
    this.addSearchFieldTitle,
    this.onChanged,
    this.onEditingComplete,
    this.searchFieldHeight,
    this.searchFieldWidth,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController searchController = TextEditingController();
  bool searchFunc = false;
  final log = getLogger();
  onClickBackBtn() {
    log.i("onClickBackBtn started");
    Navigator.pop(context);
  }

  onClickSearchButton() {
    log.i("onClickSearchButton started");
    setState(() {
      searchFunc = true;
    });
  }

  onClickSuffixIcon() {
    setState(() {
      searchFunc = false;
    });
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
        buildAppBarRowLeftSide(),
        searchFunc ? searchNotificationsField() : buildSearchBtn(),
      ],
    );
  }

  Container searchNotificationsField() {
    return Container(
      padding: EdgeInsets.only(right: 3.w),
      width: widget.searchFieldWidth ?? 72.w,
      height: widget.searchFieldHeight ?? 5.62.h,
      child: SearchChallengesField(
        onTapSuffixIcon: onClickSuffixIcon,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        addSearchFieldTitle: widget.addSearchFieldTitle,
        controller: searchController,
        serverSearchErrorText: null, //todo send server error here
      ),
    );
  }

  Row buildAppBarRowLeftSide() {
    return Row(
      children: [
        buildBackBtn(),
        buildBankImage(),
      ],
    );
  }

  Padding buildSearchBtn() {
    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: IconButton(
        onPressed: () {
          onClickSearchButton();
        },
        icon: Icon(
          Icons.search,
          color: AppColors.allNotificationsTextColor,
          size: 20.sp,
        ),
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
        color: AppColors.allNotificationsTextColor,
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
