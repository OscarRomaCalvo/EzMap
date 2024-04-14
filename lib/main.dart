import 'dart:async';

import 'package:ez_maps/pages/InitSessionPage.dart';
import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:ez_maps/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/pages/PermissionScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
    return  MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
              create: (context) => AuthService()),
        ],
        builder: (context, child) {
          print("ACUTAL USER");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: context.watch<AuthService>().user == null ?
            InitSessionPage() : const RouteSelectionPage(),
          );
        });
  }
}