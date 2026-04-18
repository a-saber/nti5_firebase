import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/cubit/register/register_state.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterState>{
  RegisterCubit(this.repo) : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  final AuthRepo repo;

  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var formKey = GlobalKey<FormState>();


  void register() async{
    if(formKey.currentState?.validate() == false) return;
    if(password.text != confirmPassword.text){
      emit(RegisterError('Passwords don\'t match'));
      return;
    }

    emit(RegisterLoading());
    var result = await repo.register(
      emailAddress: email.text,
      name: name.text,
      phone: phone.text,
      password: password.text
    );
    result.fold(
        (error)=> emit(RegisterError(error)),
        (u)=> emit(RegisterSuccess())
    );
  }

}