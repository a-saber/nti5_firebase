import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';
import 'package:nti5_firebase/features/home/cubit/user_data/user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState>{
  UserDataCubit(this.repo) : super(UserDataInitial());
  final AuthRepo repo;
  static UserDataCubit get(context) => BlocProvider.of(context);

  loadUserData()async{
    emit(UserDataLoading());
    var result = await repo.getUserData();
    result.fold(
            (error) => emit(UserDataError(error)),
            (model) => emit(UserDataSuccess(model))
    );
  }
}