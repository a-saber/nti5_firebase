import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';
import 'package:nti5_firebase/features/home/cubit/user_data/user_data_cubit.dart';

import '../cubit/user_data/user_data_state.dart';
import 'new_task_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTaskView()));
      }),
      appBar: AppBar(
        title: BlocProvider(
            create: (context)=> UserDataCubit(AuthRepo())..loadUserData(),
            child: BlocBuilder<UserDataCubit, UserDataState>(
              builder: (context, state) {
                String name = '';
                if(state is UserDataSuccess){
                  name = state.userModel.name ?? '';
                }
                return Text('Welcome $name');

              }
            )),
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginView()), (r)=>false);
            }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
