import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

class AuthRepo{
  Future<Either<String, UserModel>> register({
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

      var user = UserModel(
        email: emailAddress,
        phone: phone,
        name: name,
        id: credential.user!.uid
      );
      return right(user);

    } catch (e) {
      if(e is FirebaseAuthException){
      if (e.code == 'weak-password') {
        return left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return left('The account already exists for that email.');
      }
    }
      print(e.toString());
      return left('error has happened');
    }
  }
}