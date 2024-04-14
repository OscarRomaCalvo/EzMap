import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class InitSessionPage extends StatefulWidget {
  @override
  _InitSessionPageState createState() => _InitSessionPageState();
}

class _InitSessionPageState extends State<InitSessionPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('User Email: ${_authService.user != null ? _authService.user?.email : 'NONE'}'),
          ElevatedButton(
            onPressed: () async {
              await _authService.signInWithGoogle();
            },
            child: Text('Sign In with Google'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
            },
            child: Text('Sign Out'),
          ),
        ],
      )
    );
  }
}