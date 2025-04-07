// Importation des bibliothèques nécessaires pour l'application
import 'package:app_stage/services/auth_service.dart';
// Importation de la bibliothèque Firebase Auth pour la gestion des utilisateurs
import 'package:firebase_auth/firebase_auth.dart';
// Importation de la bibliothèque Flutter pour la création de l'interface utilisateur
import 'package:flutter/material.dart';
// Importation de la bibliothèque Google Fonts pour la personnalisation des polices
import 'package:google_fonts/google_fonts.dart';

// Définition de la classe Home pour la page d'accueil de l'application
class Home extends StatelessWidget {
  // Constructeur de la classe Home
  const Home({super.key});

  @override
  // Méthode build pour construire l'interface utilisateur
  Widget build(BuildContext context) {
    return Scaffold(
      // Définition de la couleur de fond de la page
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      // Corps principal de la page
      body: SafeArea(
        // Ajout d'un padding pour éviter les erreurs de mise en page
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // Utilisation d'une colonne pour organiser les éléments de la page
          child: Column(
            // Alignement des éléments au centre de la page
            mainAxisAlignment: MainAxisAlignment.center,
            // Liste des éléments de la page
            children: [
              // Affichage du message de bienvenue
              Text(
                'Bienvenu 👋🏾',
                // Utilisation de la police Raleway pour le texte
                style: GoogleFonts.raleway(
                  // Définition du style du texte
                  textStyle: const TextStyle(
                    color: Colors.black, // Couleur du texte
                    fontWeight: FontWeight.bold, // Police en gras
                    fontSize: 20, // Taille du texte
                  ),
                ),
              ),
              // Ajout d'un espace entre les éléments
              const SizedBox(height: 10),
              // Affichage de l'adresse e-mail de l'utilisateur
              Text(
                // Récupération de l'adresse e-mail de l'utilisateur actuel
                FirebaseAuth.instance.currentUser!.email.toString(),
                // Utilisation de la police Raleway pour le texte
                style: GoogleFonts.raleway(
                  // Définition du style du texte
                  textStyle: const TextStyle(
                    color: Colors.black, // Couleur du texte
                    fontWeight: FontWeight.bold, // Police en gras
                    fontSize: 20, // Taille du texte
                  ),
                ),
              ),
              // Ajout d'un espace entre les éléments
              const SizedBox(height: 30),
              // Appel à la méthode _logout pour afficher le bouton de déconnexion
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

   // Méthode _logout pour afficher le bouton de déconnexion
  Widget _logout(BuildContext context) {
    return ElevatedButton(
      // Définition du style du bouton
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD), // Couleur de fond du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14), // Coins arrondis du bouton
        ),
        minimumSize: const Size(double.infinity, 60), // Taille minimale du bouton
        elevation: 0, // Pas d'effet d'ombre sous le bouton
      ),
      // Action à effectuer lorsque le bouton est pressé
      onPressed: () async {
        // Appel à la méthode signout de la classe AuthService pour déconnecter l'utilisateur
        await AuthService().signout(context: context);
      },
      // Texte affiché sur le bouton, en gras et en noir
      child: const Text(
        "Déconnexion", // Texte du bouton
        style: TextStyle(
          fontWeight: FontWeight.bold, // Applique le gras au texte
          color: Colors.black, // Applique la couleur noire au texte
        ),
      ),
    );
  }

}