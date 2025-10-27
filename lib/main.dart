import 'package:auth_demo/auth_gate.dart';
import 'package:auth_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //S'assurer que tout les services sont chargés avant de lancer l'App
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    //Permet à l'app de détecter automatiquement la plateforme sur laquelle on se trouve
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
