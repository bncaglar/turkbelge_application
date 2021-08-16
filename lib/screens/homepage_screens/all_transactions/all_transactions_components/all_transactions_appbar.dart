import 'package:flutter/material.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logger/simple_log_printer.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/widgets/search_field.dart';

class AllTransactionsAppBar extends StatefulWidget {
  final String? addSearchFieldTitle;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onChanged;
  final double? searchFieldWidth;
  final double? searchFieldHeight;
  final VoidCallback? onClickMoreVert;

  AllTransactionsAppBar(
      {this.searchFieldHeight,
      required this.searchFieldWidth,
      this.addSearchFieldTitle,
      this.onChanged,
      this.onEditingComplete,
      this.onClickMoreVert});

  @override
  _AllTransactionsAppBarState createState() => _AllTransactionsAppBarState();
}

class _AllTransactionsAppBarState extends State<AllTransactionsAppBar> {
  final log = getLogger();
  bool searchFunc = false;
  onClickSuffixIcon() {
    setState(() {
      searchFunc = false;
    });
  }

  onClickSearchButton() {
    log.i("onClickSearchButton started");
    setState(() {
      searchFunc = true;
    });
  }

  TextEditingController searchController = TextEditingController();
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
        buildMoreVert(),
        searchFunc ? Container() : addHeader(),
        searchFunc ? searchNotificationsField() : buildSearchBtn(),
      ],
    );
  }

  Container buildMoreVert() {
    return Container(
      padding: EdgeInsets.only(left: 2.w),
      width: 10.w,
      child: IconButton(
        onPressed: widget.onClickMoreVert,
        icon: Icon(
          Icons.more_vert,
          color: AppColors.backgroundPrimaryColor,
          size: 28,
        ),
      ),
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

  Text addHeader() {
    return Text(
      "Tüm Hareketler",
      style: TextStyle(
        fontSize: LocalHelper.getFontSize(16),
        color: AppColors.allNotificationsTextColor,
        fontWeight: FontWeight.w400,
      ),
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
}
