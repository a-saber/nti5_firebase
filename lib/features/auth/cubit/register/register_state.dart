import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

abstract class RegisterState{}

class RegisterInitial extends RegisterState{}

class RegisterLoading extends RegisterState{}

class RegisterSuccess extends RegisterState{
  UserModel userModel;
  RegisterSuccess(this.userModel);
}

class RegisterError extends RegisterState{
  String error;
  RegisterError(this.error);
}