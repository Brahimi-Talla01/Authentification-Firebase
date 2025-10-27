import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() async {
    await Future.delayed(const Duration(milliseconds: 250));

    await FirebaseAuth.instance.signOut();
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentUser != null && currentUser!.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(currentUser!.photoURL!),
              ),
            Text("Bienvenue sur l'App"),
            Text("Nom : ${currentUser!.displayName ?? "_"}"),
            Text("Email : ${currentUser!.email ?? "_"}"),
            SizedBox(height: 10),
            ElevatedButton(onPressed: logout, child: Text("Déconnexion")),
          ],
        ),
      ),
    );
  }
}
