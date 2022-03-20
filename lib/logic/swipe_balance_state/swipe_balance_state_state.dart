part of 'swipe_balance_state_cubit.dart';

@immutable
abstract class SwipeBalanceStateState {}

class SwipeBalanceStateInitial extends SwipeBalanceStateState {}

class BalanceState extends SwipeBalanceStateState {}

class BlockedBalanceState extends SwipeBalanceStateState {}
