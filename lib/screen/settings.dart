import 'package:flutter/material.dart';
import 'package:terature/services/auth_service.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
              onPressed: () async {
                await AuthService.signOut();
              },
              icon: Icon(Icons.logout))),
    );
  }
}
