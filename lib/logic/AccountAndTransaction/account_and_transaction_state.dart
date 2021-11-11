part of 'account_and_transaction_cubit.dart';

@immutable
abstract class AccountAndTransactionState {
  final String? bankCode;
  AccountAndTransactionState({required this.bankCode});
}

class AccountAndTransactionInitial extends AccountAndTransactionState {
  AccountAndTransactionInitial() : super(bankCode: "ALL");
}

class AccountAndTransactionEmit extends AccountAndTransactionState {
  final String? bankCode;
  AccountAndTransactionEmit({
    required this.bankCode,
  }) : super(bankCode: bankCode);

}
