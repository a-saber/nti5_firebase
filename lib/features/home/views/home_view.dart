import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key, this.userModel});

  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${userModel?.name}'),
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
