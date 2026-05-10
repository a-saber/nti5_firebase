import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/home/data/repo/tasks_repo.dart';

import 'user_data_states.dart';

class UserDataCubit extends Cubit<UserDataStates> {
  UserDataCubit() : super(UserDataInitialState());

  static UserDataCubit get(context) => BlocProvider.of(context);

  TasksRepo repo = TasksRepo();

  void getUserData() async {

    emit(UserDataLoadingState());
    var result = await repo.getUserData();

    result.fold(
            (e)=> emit(UserDataErrorState(e)),
            (userModel)=> emit(UserDataSuccessState(userModel))
    );
  }
}
