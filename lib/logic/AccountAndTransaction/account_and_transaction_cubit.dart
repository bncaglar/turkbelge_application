import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'account_and_transaction_state.dart';

class AccountAndTransactionCubit extends Cubit<AccountAndTransactionState> {
  AccountAndTransactionCubit() : super(AccountAndTransactionInitial());

  changState(AccountAndTransactionState state){
    emit(state);
  }
  String getBankCode(){
    return state.bankCode!;
  }
}
