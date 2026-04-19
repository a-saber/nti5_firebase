import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';
import 'package:nti5_firebase/features/auth/data/repo/auth_repo.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';
import 'package:nti5_firebase/features/home/cubit/user_data/user_data_cubit.dart';
import 'package:nti5_firebase/features/home/data/models/task_model.dart';

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
      // appBar: AppBar(
      //   title: BlocProvider(
      //       create: (context)=> UserDataCubit(AuthRepo())..loadUserData(),
      //       child: BlocBuilder<UserDataCubit, UserDataState>(
      //         builder: (context, state) {
      //           String name = '';
      //           if(state is UserDataSuccess){
      //             name = state.userModel.name ?? '';
      //           }
      //           return Text('Welcome $name');
      //
      //         }
      //       )),
      //   actions: [
      //     IconButton(
      //       onPressed: ()async{
      //         await FirebaseAuth.instance.signOut();
      //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginView()), (r)=>false);
      //       }, icon: Icon(Icons.logout))
      //   ],
      // ),
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: ()async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginView()), (r)=>false);
              }, icon: Icon(Icons.logout))
          ],
        title: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot){
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              UserModel userModel = UserModel.fromJson(data);
              return Text("Welcome ${userModel.name}");
            }

            return Text("loading");
          }
        ),
      ),
      body: TasksStreamBuilder(),
    );
  }
}
class TasksStreamBuilder extends StatelessWidget {
  const TasksStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks').snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          List<TaskModel> tasks =
          snapshot.data!.docs.map((doc)=> TaskModel.fromJson(doc.data() as Map<String, dynamic>)..id = doc.id).toList();
          return ListView.separated(
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    Text(tasks[index].title??''),
                    Text(tasks[index].description??''),
                    Text(tasks[index].dateTime.toString()),
                  ],),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: tasks.length
          );



        });
  }
}



class TasksFutureBuilder extends StatelessWidget {
  const TasksFutureBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks').get(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("Something went wrong");
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            List<TaskModel> tasks =
            snapshot.data!.docs.map((doc)=> TaskModel.fromJson(doc.data())..id = doc.id).toList();
            return ListView.separated(
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      Text(tasks[index].title??''),
                      Text(tasks[index].description??''),
                      Text(tasks[index].dateTime.toString()),
                    ],),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: tasks.length
            );
          }
          return Text("loading");


        });
  }
}
