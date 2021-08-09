import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'firebase_state_management_state.dart';

class FirebaseStateManagementCubit extends Cubit<FirebaseStateManagementState> {
  FirebaseStateManagementCubit() : super(FirebaseUnAuthorized());

  changeAuthenticationState(FirebaseStateManagementState state) async {
    emit(state);
  }
}
