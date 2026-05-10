import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

abstract class UserDataStates {}

class UserDataInitialState extends UserDataStates {}
class UserDataLoadingState extends UserDataStates {}
class UserDataSuccessState extends UserDataStates {
  final UserModel userModel;

  UserDataSuccessState(this.userModel);
}
class UserDataErrorState extends UserDataStates {
  final String error;
  UserDataErrorState(this.error);
}