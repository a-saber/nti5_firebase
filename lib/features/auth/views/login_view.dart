import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';

import '../../home/views/home_view.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';
import 'register_view.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> LoginCubit(AuthRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state){
            if( state is LoginSuccess){
              Fluttertoast.showToast(
                  msg: "Logged in Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context)=> HomeView(
                    userModel: state.userModel,
                  )),
                  (r)=> false
              );

            }
            else if(state is LoginError){
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          builder: (context, state){
            var cubit = LoginCubit.get(context);
            return Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children:
                    [

                      TextFormField(
                        controller: cubit.email,
                        decoration: InputDecoration(
                          labelText: 'email',
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'email is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: cubit.password,
                        decoration: InputDecoration(
                          labelText: 'password',
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40,),

                      if(state is LoginLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                            onPressed: cubit.login,
                            child: Text('Login')
                        ),

                      SizedBox(height: 40,),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterView()));
                      },
                          child: Text('Don\'t have an account? Register'))

                    ],

                  ),
                )
            );
          },
        ),
      ),

    );
  }
}
