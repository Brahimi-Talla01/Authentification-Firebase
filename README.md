# Auth Demo - Solution d'Authentification Flutter avec Firebase

## Description

Ce projet Flutter démontre une solution complète et réutilisable pour l’authentification mobile avec Firebase.  
Il inclut l’inscription, la connexion, la validation des formulaires, la connexion Google et la redirection automatique après authentification.

## Fonctionnalités

- Authentification par e-mail et mot de passe  
- Validation des formulaires  
- Indicateur de chargement  
- Connexion via Google  
- Redirection après connexion/inscription  

## Prérequis

- Flutter SDK  
- Android Studio (ou VS Code avec extensions Flutter)  
- Un compte Firebase  

## Installation

```bash
git clone https://github.com/Brahimi-Talla01/Authentification-Firebase.git
cd auth_demo
flutter pub get
````

## Configuration Firebase

1. Créez un projet sur [Firebase Console](https://console.firebase.google.com)
2. Activez les méthodes de connexion : **Email/Mot de passe** et **Google**
3. Ajoutez une application Android :

   * Package name : `com.example.nomduprojet`
4. Générez vos clés SHA-1 et SHA-256 :

   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Téléchargez le fichier `google-services.json` et placez-le dans `android/app/`

### Firestore (si utilisé)

Activez Firestore et ajoutez ces règles de développement :

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Exécution

```bash
flutter run
```

En cas de problème :

```bash
flutter clean
flutter pub get
flutter run
```

## Structure du projet
```bash
lib/
├── models/
│   └── user_model.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   └── splash_screen.dart
├── utils/
│   └── constants.dart
└── main.dart
```

## Auteur

Projet réalisé par **Brahimi**  
Email : [ibrahimtalla01@gmail.com](mailto:ibrahimtalla01@gmail.com)  
Portfolio : [https://brahim-i.vercel.app](https://brahim-i.vercel.app)  
Année : 2025

