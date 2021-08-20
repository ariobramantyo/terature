import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: (user!.displayName == null)
            ? FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .doc(user!.uid)
                    .collection('data')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text(snapshot.data!.docs[0]['name']),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            : Center(
                child: Text(user!.displayName ?? ''),
              ));
  }
}
