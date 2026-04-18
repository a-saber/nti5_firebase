import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit(this.repo) : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  final AuthRepo repo;

  var email = TextEditingController();
  var password = TextEditingController();
  var formKey = GlobalKey<FormState>();


  void login() async{
    if(formKey.currentState?.validate() == false) return;


    emit(LoginLoading());
    var result = await repo.login(
      emailAddress: email.text,
      password: password.text
    );
    result.fold(
        (error)=> emit(LoginError(error)),
        (model)=> emit(LoginSuccess(model))
    );
  }

}