// Importation des bibliothèques nécessaires
import 'package:firebase_auth/firebase_auth.dart'; // Gestion de l'authentification Firebase
import 'package:flutter/material.dart'; // Widgets Flutter
import 'package:fluttertoast/fluttertoast.dart'; // Pour afficher des notifications toast
import 'package:app_stage/pages/home/home_page.dart'; // Page d'accueil
import 'package:app_stage/pages/login/login_page.dart'; // Page de connexion

// Classe pour gérer les services d'authentification Firebase
class AuthService {
  // Méthode pour créer un compte utilisateur
  Future<void> signup({
    required String email, // Adresse email de l'utilisateur
    required String password, // Mot de passe de l'utilisateur
    required BuildContext context, // Contexte actuel de l'application
  }) async {
    try {
      // Création d'un compte avec email et mot de passe
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Temporisation pour afficher la prochaine page
      await Future.delayed(const Duration(seconds: 1));
      // Navigation vers la page d'accueil après création du compte
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques de Firebase
      String message = ''; // Message d'erreur à afficher
      if (e.code == 'weak-password') {
        // Si le mot de passe est trop faible
        message = 'Le mot de passe fourni est trop faible.';
      } else if (e.code == 'email-already-in-use') {
        // Si l'email est déjà utilisé
        message = 'Un compte existe déjà avec cet email.';
      }
      // Affichage d'une notification toast pour signaler l'erreur
      Fluttertoast.showToast(
        msg: message, // Message d'erreur
        toastLength: Toast.LENGTH_LONG, // Durée d'affichage du toast
        gravity: ToastGravity.SNACKBAR, // Position du toast
        backgroundColor: Colors.black54, // Couleur de fond du toast
        textColor: Colors.white, // Couleur du texte du toast
        fontSize: 14.0, // Taille de la police du texte
      );
    } catch (e) {
      // Gestion d'une erreur générique
      Fluttertoast.showToast(
        msg: 'Une erreur est survenue. Veuillez réessayer.', // Message générique
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red, // Couleur du toast en cas d'erreur
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Méthode pour connecter un utilisateur
  Future<void> signin({
    required String email, // Adresse email de l'utilisateur
    required String password, // Mot de passe de l'utilisateur
    required BuildContext context, // Contexte actuel de l'application
  }) async {
    try {
      // Connexion avec email et mot de passe
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Temporisation pour afficher la prochaine page
      await Future.delayed(const Duration(seconds: 1));
      // Navigation vers la page d'accueil après connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques de Firebase
      String message = ''; // Message d'erreur à afficher
      if (e.code == 'invalid-email') {
        // Si l'email est invalide ou non trouvé
        message = 'Aucun utilisateur trouvé pour cet email.';
      } else if (e.code == 'wrong-password') {
        // Si le mot de passe est incorrect
        message = 'Le mot de passe fourni est incorrect.';
      }
      // Affichage d'une notification toast pour signaler l'erreur
      Fluttertoast.showToast(
        msg: message, // Message d'erreur
        toastLength: Toast.LENGTH_LONG, // Durée d'affichage du toast
        gravity: ToastGravity.SNACKBAR, // Position du toast
        backgroundColor: Colors.black54, // Couleur de fond du toast
        textColor: Colors.white, // Couleur du texte du toast
        fontSize: 14.0, // Taille de la police du texte
      );
    } catch (e) {
      // Gestion d'une erreur générique
      Fluttertoast.showToast(
        msg: 'Une erreur est survenue. Veuillez réessayer.', // Message générique
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red, // Couleur du toast en cas d'erreur
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Méthode pour déconnecter un utilisateur
  Future<void> signout({required BuildContext context}) async {
    // Déconnexion de l'utilisateur de Firebase
    await FirebaseAuth.instance.signOut();
    // Temporisation avant de naviguer vers la page de connexion
    await Future.delayed(const Duration(seconds: 1));
    // Navigation vers la page de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Login(),
      ),
    );
  }
}
