import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:turkbelge_application/helper/local_helper.dart';
import 'package:turkbelge_application/logic/currency_sm/currency_sm_cubit.dart';
import 'package:turkbelge_application/logic/dropdown_sm/dropdown_cubit.dart';
import 'package:turkbelge_application/logic/groupCompany_sm/group_company_sm_cubit.dart';
import 'package:turkbelge_application/utilities/colors.dart';

class DropDownDemo extends StatefulWidget {
  @override
  _DropDownDemoState createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
  String? _chosenValue;
  List<String> items = [
    "İleka Akademi A.Ş.".toUpperCase(),
    'İleka Telekominikasyon A.Ş.',
  ];

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        height: 8.h,
        width: double.infinity,
        child: Center(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: AppColors.dismissRedColor.withOpacity(0.85),
            ),
            child: DropdownButton<String>(
              value: _chosenValue,
              elevation: 5,
              autofocus: false,
              focusColor: Colors.transparent,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryWightColor,),
              style: TextStyle(color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: 70.54.w,
                    child: Text(value.toUpperCase(),style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: LocalHelper.getFontSize(13),
                      color: AppColors.primaryWightColor,
                    ),),
                  ),
                );
              }).toList(),
              hint: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildGroupCompany(),
                ],
              ),
              onChanged: (String? value) {
                setState(() {
                  _chosenValue = value!;
                });
                onChanged();
              },
            ),
          ),
        ),
      ),
    );
  }

  void onChanged(){
    if(_chosenValue == items[0]){
      context.read<DropdownCubit>().changeDropdownState(DropdownInitial());
    }else if(_chosenValue == items[1]){
      context.read<DropdownCubit>().changeDropdownState(DropdownSecondCompany());
    }
  }

  BlocBuilder buildGroupCompany(){
    return BlocBuilder<DropdownCubit, DropdownState>(
        builder: (context, state){
          if(state is DropdownInitial){
            return Text(
              items[0].toString().trim().toUpperCase(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(13),
                color: AppColors.primaryWightColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            );
          }else if(state is DropdownSecondCompany){
            return Text(
              items[1].toString().trim().toUpperCase(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: LocalHelper.getFontSize(13),
                color: AppColors.primaryWightColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            );
          }
          return Container();
        }
    );
  }

}