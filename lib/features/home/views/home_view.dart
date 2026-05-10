import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';
import 'package:nti5_firebase/features/home/cubit/get_user_data/user_data_cubit.dart';
import 'package:nti5_firebase/features/home/cubit/get_user_data/user_data_states.dart';

import '../cubit/get_tasks/get_tasks_cubit.dart';
import '../cubit/get_tasks/get_tasks_state.dart';
import '../data/models/task_model.dart';
import 'add_task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskView()));
          }),
      appBar: AppBar(
        title:
            // using future Builder
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    UserModel userModel =
                        UserModel.fromJson(snapshot.data!.data()!);
                    return Text('Welcome ${userModel.name}');
                  }
                  return Text('Welcome');
                }),

        // using cubit
        // title: BlocProvider(
        //     create: (context) => UserDataCubit()..getUserData(),
        //     child: BlocBuilder<UserDataCubit, UserDataStates>(
        //         builder: (context, state) {
        //       String username = '';
        //       if (state is UserDataSuccessState) {
        //         username = state.userModel.name ?? '';
        //       }
        //       return Text('Welcome $username');
        //     })),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (r) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      // using stream builder
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('tasks')
              .snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<TaskModel> tasks = snapshot.data!.docs
                .map((e) => TaskModel.fromJson(e.data()))
                .toList();
            return ListView.separated(
                padding: EdgeInsets.all(20),
                itemBuilder: (context, index) => TaskItemBuilder(
                      // getTasksCubit: GetTasksCubit.get(context),
                      model: tasks[index],
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                itemCount: tasks.length);

          }),

      // using Future builder
      // body: FutureBuilder(
      //     future: FirebaseFirestore.instance
      //         .collection('users')
      //         .doc(FirebaseAuth.instance.currentUser?.uid)
      //         .collection('tasks')
      //         .get(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         List<TaskModel> tasks = snapshot.data!.docs
      //             .map((e) => TaskModel.fromJson(e.data()))
      //             .toList();
      //         return ListView.separated(
      //             padding: EdgeInsets.all(20),
      //             itemBuilder: (context, index) => TaskItemBuilder(
      //                   // getTasksCubit: GetTasksCubit.get(context),
      //                   model: tasks[index],
      //                 ),
      //             separatorBuilder: (context, index) => SizedBox(
      //                   height: 20,
      //                 ),
      //             itemCount: tasks.length);
      //       }
      //       return Center(child: CircularProgressIndicator());
      //     }),

      // body: BlocProvider(
      //   create: (c)=> GetTasksCubit()..getTasks(),
      //   child: BlocBuilder<GetTasksCubit, GetTasksState>(
      //       builder: (context, state) {
      //         if(state is GetTasksLoadingState){
      //           return Center(child: CircularProgressIndicator(),);
      //         }
      //         else if(state is GetTasksErrorState){
      //           return Center(child: Text(state.error),);
      //         }
      //         else if(state is GetTasksSuccessState){
      //           return RefreshIndicator(
      //             onRefresh: ()async{
      //              await GetTasksCubit.get(context).getTasks();
      //             },
      //             child: ListView.separated(
      //                 padding: EdgeInsets.all(20),
      //                 itemBuilder: (context, index) => TaskItemBuilder(
      //                   // getTasksCubit: GetTasksCubit.get(context),
      //                   model: state.tasks[index],
      //                 ),
      //                 separatorBuilder: (context, index) => SizedBox(height: 20,),
      //                 itemCount: state.tasks.length
      //             ),
      //           );
      //         }
      //         return Container();
      //       }
      //   ),
      // ),
    );
  }
}

class TaskItemBuilder extends StatelessWidget {
  const TaskItemBuilder({
    super.key,
    required this.model,
    // required this.getTasksCubit
  });

  // final GetTasksCubit getTasksCubit;
  final TaskModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // goTo(context, UpdateTaskView(
        //   taskModel: model,
        //   getTasksCubit: getTasksCubit,
        // ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffCEEBDC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                  color: Colors.black.withValues(alpha: 0.25)),
            ]),
        padding: EdgeInsets.all(13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(model.title ?? ''),
                  SizedBox(
                    height: 13,
                  ),
                  Text(model.description ?? ''),
                ],
              ),
            ),
            Expanded(
                child: Text(
              model.dateTime.toString() ?? '',
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    );
  }
}
