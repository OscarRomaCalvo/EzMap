import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class InitSessionPage extends StatefulWidget {
  @override
  _InitSessionPageState createState() => _InitSessionPageState();
}

class _InitSessionPageState extends State<InitSessionPage> {
  final AuthService _authService = AuthService();

  @override
  void initState(){
    super.initState();
    _startUserListener();
  }

  void _startUserListener() {
    AuthService.userStream.listen((User? user) {
      if (user == null) {
        print("USER IS NULL");
      } else {
        print("USUARIO");
        print(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RouteSelectionPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Persistent User Authentication'),
        ),
        body: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final user = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('User Email: ${user != null ? user.email : 'NONE'}'),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}