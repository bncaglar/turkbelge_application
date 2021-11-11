import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dropdown_state.dart';

class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownInitial());

  changeDropdownState(DropdownState state){
    emit(state);
  }
}
