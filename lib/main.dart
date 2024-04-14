import 'dart:async';

import 'package:ez_maps/pages/InitSessionPage.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/pages/PermissionScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.location.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'EZ maps',
            theme: ThemeData(),
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.data == PermissionStatus.granted) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(),
              home: InitSessionPage(),
            );
          } else {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(),
              home: PermissionScreen(),
            );
          }
        }
      },
    );
  }
}