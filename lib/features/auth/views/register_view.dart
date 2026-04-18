import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nti5_firebase/features/auth/cubit/register/register_cubit.dart';
import 'package:nti5_firebase/features/auth/cubit/register/register_state.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> RegisterCubit(AuthRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state){
            if( state is RegisterSuccess){
              Fluttertoast.showToast(
                  msg: "Registered Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              // TODO: Navigate to home
            }
            else if(state is RegisterError){
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
            var cubit = RegisterCubit.get(context);
            return Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children:
                  [
                    TextFormField(
                      controller: cubit.name,
                      decoration: InputDecoration(
                        labelText: 'name',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                     TextFormField(
                      controller: cubit.phone,
                      decoration: InputDecoration(
                        labelText: 'phone',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'phone is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
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
                    SizedBox(height: 20,),
                     TextFormField(
                      controller: cubit.confirmPassword,
                      decoration: InputDecoration(
                        labelText: 'confirm Password',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'confirm Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40,),
                    
                    if(state is RegisterLoading)
                      CircularProgressIndicator()
                    else 
                      ElevatedButton(
                          onPressed: cubit.register,
                          child: Text('Register')
                      )

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
