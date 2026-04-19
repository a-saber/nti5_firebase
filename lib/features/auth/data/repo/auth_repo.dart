import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

class AuthRepo{
  Future<Either<String, Unit>> register({
    required String emailAddress,
    required String name,
    required String phone,
    required String password
})async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user?.sendEmailVerification();

      UserModel userModel = UserModel(
        email: emailAddress,
        name: name,
        phone: phone,
        id: credential.user?.uid
      );

      await FirebaseFirestore.instance.collection('users')
      .doc(userModel.id).set(userModel.toJson());
      return right(unit);

    } catch (e) {
      print('Error Register: ${e.toString()}');
      if(e is FirebaseAuthException){
      if (e.code == 'weak-password') {
        return left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return left('The account already exists for that email.');
      }
      return left('${e.code} ${e.message}');
    }
      return left('error has happened');
    }
  }
  Future<Either<String, Unit>> login({
    required String emailAddress,
    required String password
})async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if(credential.user!.emailVerified){
        return right(unit);
      }
      else {
        return left('Please verify your email first');
      }



    } catch (e) {
      if(e is FirebaseAuthException){
        if (e.code == 'user-not-found') {
          return left('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          return left('Wrong password provided for that user.');
        }
        return left('${e.code} ${e.message}');
    }
      print(e.toString());
      return left('error has happened');
    }
  }
  Future<Either<String, UserModel>> getUserData()async{
    try {
        if(FirebaseAuth.instance.currentUser != null) {
          var response = await FirebaseFirestore.instance.collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid).get();
          var user = UserModel.fromJson(response.data()!)
            ..id = FirebaseAuth.instance.currentUser!.uid;

          return right(user);
        }
        else{
          return left('User is Signed out');
        }

    } catch (e) {
      if(e is FirebaseAuthException){
        if (e.code == 'user-not-found') {
          return left('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          return left('Wrong password provided for that user.');
        }
        return left('${e.code} ${e.message}');
    }
      print(e.toString());
      return left('error has happened');
    }
  }
}