import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chart_sm_state.dart';

class ChartSmCubit extends Cubit<ChartSmState> {
  ChartSmCubit() : super(ChartSmInitial());

  changeChartState(ChartSmState state){
    emit(state);
  }
}
