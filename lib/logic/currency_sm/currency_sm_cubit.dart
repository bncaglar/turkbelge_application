import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'currency_sm_state.dart';

class CurrencySmCubit extends Cubit<CurrencySmState> {
  CurrencySmCubit() : super(CurrencySmInitial());

  changeCurrencyState(CurrencySmState state){
    emit(state);
  }
}
