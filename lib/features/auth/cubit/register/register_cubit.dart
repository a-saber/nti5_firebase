import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  AuthRepo repo = AuthRepo();

  void onRegisterPressed() async {
    if (formKey.currentState?.validate() == false) return;

    emit(RegisterLoadingState());
    var result = await repo.register(
        email: email.text,
        password: password.text,
        name: name.text,
        phone: phone.text
    );

    result.fold(
        (e)=> emit(RegisterErrorState(e)),
        (u)=> emit(RegisterSuccessState())
    );
  }
}
