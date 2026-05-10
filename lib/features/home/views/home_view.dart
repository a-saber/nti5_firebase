import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

import 'add_task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, this.userModel});

  final UserModel? userModel;

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
        title: Text('Welcome ${userModel?.name}'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      // body: ,
    );
  }
}
