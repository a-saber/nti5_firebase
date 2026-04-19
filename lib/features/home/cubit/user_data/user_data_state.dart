import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

abstract class UserDataState{}


class UserDataInitial extends UserDataState{}

class UserDataLoading extends UserDataState{}

class UserDataSuccess extends UserDataState{
  UserModel userModel;
  UserDataSuccess(this.userModel);
}

class UserDataError extends UserDataState{
  String error;
  UserDataError(this.error);
}