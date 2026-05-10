import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nti5_firebase/features/auth/cubit/register/register_cubit.dart';
import 'package:nti5_firebase/features/auth/cubit/register/register_state.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';
import 'package:nti5_firebase/features/home/views/home_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if(state is RegisterSuccessState){
                Fluttertoast.showToast(
                    msg: "Registered Successfully\nPlease Verify Your Email then Login",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView()));
              }
              else if(state is RegisterErrorState){
                Fluttertoast.showToast(
                    msg: state.error,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: RegisterCubit.get(context).formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      controller: RegisterCubit.get(context).email,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      controller: RegisterCubit.get(context).password,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                      controller: RegisterCubit.get(context).name,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Phone',
                      ),
                      controller: RegisterCubit.get(context).phone,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Phone is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    state is RegisterLoadingState?
                    Center(child: CircularProgressIndicator()):
                    ElevatedButton(onPressed: RegisterCubit.get(context).onRegisterPressed, child: Text('Register')),

                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
