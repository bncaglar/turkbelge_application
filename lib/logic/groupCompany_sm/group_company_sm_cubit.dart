import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'group_company_sm_state.dart';

class GroupCompanySmCubit extends Cubit<GroupCompanySmState> {
  GroupCompanySmCubit() : super(GroupCompanySmInitial());

  changeCompany(GroupCompanySmState state){
    emit(state);
  }
}
