part of 'firebase_state_management_cubit.dart';

@immutable
abstract class FirebaseStateManagementState {}

class FirebaseAuthorized extends FirebaseStateManagementState {}

class FirebaseUnAuthorized extends FirebaseStateManagementState {}
