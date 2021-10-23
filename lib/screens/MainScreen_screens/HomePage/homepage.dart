import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:turkbelge_application/logic/chart_sm/chart_sm_cubit.dart';
import 'package:turkbelge_application/screens/MainScreen_screens/HomePage/ChartSMBlocs/PieChartState/HomePageHalfUpPie.dart';
import 'package:turkbelge_application/utilities/colors.dart';
import 'ChartSMBlocs/ChartSMInitial/homepage_half_down.dart';
import 'ChartSMBlocs/ChartSMInitial/homepage_half_up.dart';
import 'ChartSMBlocs/PieChartState/HomePageHalfDown.dart';
import 'ChartSMBlocs/SColumnChartState/HomePageColumnHalfUp.dart';
import 'ChartSMBlocs/SColumnChartState/HomePageHalfDownColumn.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryWightColor,
        body: buildChartSM(),
      ),
    );
  }

  BlocBuilder buildChartSM() {
    return BlocBuilder<ChartSmCubit, ChartSmState>(builder: (context, state) {
      if (state is ChartSmInitial) {
        return chartSmInitialBody();
      } else if (state is PieChartState) {
        return chartSMPieBody();
      } else if (state is SColumnChartState) {
        return sColumnChartStateBody();
      }
      return Container();
    });
  }

  Column chartSmInitialBody() {
    return Column(
      children: <Widget>[
        HomePageHalfUp(),
        HomePageHalfDown(),
      ],
    );
  }

  Column chartSMPieBody(){
    return Column(
      children: <Widget>[
        HomePageHalfUpPie(),
        HomePageHalfDownPie()
      ],
    );
  }

  Column sColumnChartStateBody(){
    return Column(
      children: <Widget>[
        HomePageHalfUpColumn(),
        HomePageHalfDownColumn(),
      ],
    );
  }
}
