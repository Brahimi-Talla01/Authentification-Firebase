import 'package:auth_demo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  bool _isLoading = false;

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      //Tenter de créer le compte avec l'email et le mot de passe
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Inscription Ok", textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      //Redirection vers La page de Connexion après inscription
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'email-already-in-use' => 'Email déjà utilisé',
        'invalid-email' => 'Email invalide',
        'week-password' => 'Mot de passe trop faible',
        _ => 'Erreur: ${e.code}',
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, textAlign: TextAlign.center),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fonction pour naviguer vers Connexion
  void _goToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
        backgroundColor: Colors.blue,
        shadowColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22.0),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
          //Clé du formulaire
          key: _formKey,
          child: Column(
            children: [
              // ---------- TITRE ----------
              const Text(
                "Créer un compte",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              // -----------Email---------------
              TextFormField(
                controller: emailTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ ne peut pas être vide';
                  }
                  return null;
                },

                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "exemple@gmail.com",

                  prefixIcon: const Icon(Icons.email_outlined),

                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),

                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 10),

              // -----------Password---------------
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ ne peut pas être vide';
                  }
                  return null;
                },

                controller: passwordTextController,

                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  hintText: "Doit avoir au moins 6 caractères",

                  prefixIcon: const Icon(Icons.lock),

                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(height: 10),

              // -----------Confirm Password---------------
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmez votre mot de passe';
                  }
                  if (value != passwordTextController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
                controller: confirmPasswordTextController,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  hintText: "Doit être identique",

                  prefixIcon: const Icon(Icons.lock),

                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                obscureText: true,
              ),

              SizedBox(height: 50),

              // ---------- BOUTON SE CONNECTER ----------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Créer un compte",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20),

              // ---------- LIEN CRÉER UN COMPTE ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Avez-vous déjà un compte ? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page d'inscription
                      _goToLoginScreen();
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
