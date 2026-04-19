import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TasksRepo{

  Future<Either<String, Unit>> addTask({
    required TaskModel task
  })async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks')
          .add(task.toJson());

      return right(unit);
    }
    catch (e) {
      print(e.toString());
      if(e is FirebaseException){
        return left('${e.code} ${e.message}');
      }
      else{
        return left('Something went wrong');
      }
    }
  }

}