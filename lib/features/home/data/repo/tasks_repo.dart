import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';
import 'package:nti5_firebase/features/home/data/models/task_model.dart';

class TasksRepo {
  Future<Either<String, UserModel>> getUserData() async {
    try {
      // Save user to database (fireStore)
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      var userModel = UserModel.fromJson(userDoc.data()!)..id = userDoc.id;

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return left('Wrong password provided for that user.');
      }
      return left('${e.code}, ${e.message}');
    } catch (e) {
      print(e);
      return left('Something went wrong');
    }
  }

  Future<Either<String, Unit>> addTask({
    required String title,
    required String description,
    required DateTime date,
  }) async {
    try {
      TaskModel taskModel =
          TaskModel(title: title, description: description, dateTime: date);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tasks')
          .add(taskModel.toJson());

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return left('The account already exists for that email.');
      }
      return left('${e.code}, ${e.message}');
    } catch (e) {
      print(e.toString());
      return left('Something went wrong');
    }
  }

  Future<Either<String, List<TaskModel>>> getTasks() async {
    try {
      var tasksResponse = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tasks')
          .get();
      List<TaskModel> tasks =
          tasksResponse.docs.map((e) => TaskModel.fromJson(e.data())).toList();
      return right(tasks);
    } catch (e) {
      print(e);
      return left('Something went wrong');
    }
  }
}
