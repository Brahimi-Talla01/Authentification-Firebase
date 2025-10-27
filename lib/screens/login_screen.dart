import 'package:auth_demo/screens/home_screen.dart';
import 'package:auth_demo/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingGoogle = false;
  bool _obscureText = true;

  // Choix des comptes googles
  Future<void> ensureInitialized() {
    return GoogleSignInPlatform.instance.init(const InitParameters());
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
    });

    try {
      await ensureInitialized(); //S'assurer que tout est chargé

      //Authentification
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());

      //Récupération du jéton unique
      final String? idToken = result.authenticationTokens.idToken;

      if (idToken != null) {
        //Connecté
        //Récupération de toutes les informations de l'utilisateur
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        final firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          //Message lorsque la connexion a réussie
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Connecté avec google ! ${firebaseUser.displayName ?? firebaseUser.email}",
              ),
            ),
          );
        }
      } else {
        //Message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de récupération du token Google")),
        );
      }
    } on GoogleSignInException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur signin : $e")));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur de Firebase Auth : $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGoogle = false;
        });
      }
    }
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      //Tenter de se connecter au compte avec l'email et le mot de passe
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connexion Ok", textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 250));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'user-disabled' => 'Compte désactivé',
        'invalid-email' => 'Email invalide',
        'wrong-password' => 'Mot de passe invalide',
        'user-not-found' => 'Compte non existant',
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

  // Fonction pour naviguer vers l'Inscription
  void _goToSingnInScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                "Connexion à votre compte",
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ ne peut pas être vide';
                  }
                  return null;
                },
                controller: emailTextController,

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
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  hintText: "Doit avoir au moins 6 caractères",

                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),

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
              ),

              SizedBox(height: 50),

              // ---------- BOUTON SE CONNECTER ----------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
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
                            color: Colors.blue,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- SÉPARATEUR ----------
              Row(
                children: [
                  const Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "ou connectez-vous avec",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------- BOUTON GOOGLE ----------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _isLoadingGoogle ? null : signInWithGoogle,
                  icon: Image.asset(
                    'assets/images/google_logo.webp',
                    height: 22,
                  ),
                  label: _isLoadingGoogle
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.transparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                    "Pas encore de compte ? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page d'inscription
                      _goToSingnInScreen();
                    },
                    child: const Text(
                      "Créer un compte",
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
