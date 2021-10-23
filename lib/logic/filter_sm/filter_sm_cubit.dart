import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filter_sm_state.dart';

class FilterSmCubit extends Cubit<FilterSmState> {
  FilterSmCubit() : super(FilterSmOneDay());

  changeFilterState(FilterSmState state){
    emit(state);
  }
}
