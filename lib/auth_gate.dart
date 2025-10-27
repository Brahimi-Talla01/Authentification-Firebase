import 'package:auth_demo/screens/home_screen.dart';
import 'package:auth_demo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //Requête en cours
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        //Utilisateur est connecté
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        //Non connecté
        return const LoginScreen();
      },
    );
  }
}
