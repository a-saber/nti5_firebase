import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

class AuthRepo {
  Future<Either<String, UserModel>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
})async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userModel = UserModel(id: credential.user?.uid, name: name, email: email, phone: phone);
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return left('The account already exists for that email.');
      }
      return left('${e.code}, ${e.message}');
    } catch (e) {
      print(e);
      return left('Something went wrong');
    }
  }

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
})async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userModel = UserModel(id: credential.user?.uid, email: email);

      // TODO: Email verification
      // credential.user?.emailVerified;
      // credential.user?.sendEmailVerification();
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
}