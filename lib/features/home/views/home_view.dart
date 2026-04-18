import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nti5_firebase/features/auth/views/login_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
