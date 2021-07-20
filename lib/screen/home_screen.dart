import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terature/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Color(0xFFFF7A00),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(user!.uid),
      ),
    );
  }
}
