import 'package:flutter/material.dart';
import 'package:nti5_firebase/features/auth/data/models/user_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome ${userModel.name}'),
      ),
    );
  }
}
