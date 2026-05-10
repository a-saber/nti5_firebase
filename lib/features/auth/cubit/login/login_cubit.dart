import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  var email = TextEditingController();
  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  AuthRepo repo = AuthRepo();

  void onLoginPressed() async {
    if (formKey.currentState?.validate() == false) return;

    emit(LoginLoadingState());
    var result = await repo.login(
        email: email.text,
        password: password.text,
    );

    result.fold(
        (e)=> emit(LoginErrorState(e)),
        (u)=> emit(LoginSuccessState())
    );
  }
}
