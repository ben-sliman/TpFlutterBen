import 'package:app_stage/pages/login/login_page.dart'; // Page de connexion
import 'package:app_stage/pages/home/todo_list.dart'; // Page des tâches
import 'package:firebase_auth/firebase_auth.dart'; // Authentification Firebase
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  // Inscription d'un utilisateur
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Affiche un pop-up de confirmation
      showDialog(
        context: context,
        barrierDismissible: false, // Empêche la fermeture involontaire
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Inscription réussie'),
            content: const Text('Votre compte a été créé avec succès !'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme le pop-up
                  Navigator.pushReplacement( // Redirige vers la connexion
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Login(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Mot de passe trop faible.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Cet email est déjà utilisé.';
      }
      Fluttertoast.showToast(msg: message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Une erreur est survenue.');
    }
  }

  // Connexion d'un utilisateur
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Redirige vers la page TodoList
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const TodoList(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Email invalide.';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect.';
      }
      Fluttertoast.showToast(msg: message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Une erreur est survenue.');
    }
  }

  // Déconnexion d'un utilisateur
  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();

    // Redirige vers la page de connexion
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const Login(),
      ),
    );
  }
}
