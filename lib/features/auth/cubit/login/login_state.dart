import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

abstract class LoginState{}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
  UserModel userModel ;
  LoginSuccess(this.userModel);
}

class LoginError extends LoginState{
  String error;
  LoginError(this.error);
}