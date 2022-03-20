import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'swipe_balance_state_state.dart';

class SwipeBalanceStateCubit extends Cubit<SwipeBalanceStateState> {
  SwipeBalanceStateCubit() : super(SwipeBalanceStateInitial());

  onSwipe(SwipeBalanceStateState state){
   emit(state);
  }
}
