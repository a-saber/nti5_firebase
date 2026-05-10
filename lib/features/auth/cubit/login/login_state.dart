import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final UserModel userModel;
  LoginSuccessState(this.userModel);
}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}