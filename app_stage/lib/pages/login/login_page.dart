// Importation des packages nécessaires
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_stage/services/auth_service.dart';

// Définition de la classe Login
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// Classe pour gérer l'état de l'écran de connexion
class _LoginState extends State<Login> {
  // Booléen pour déterminer si l'écran doit afficher la connexion ou l'inscription
  bool showLogin = true;

  // Contrôleurs pour les champs de saisie de l'email et du mot de passe
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  // Méthode pour construire l'arborescence des widgets de l'écran
  Widget build(BuildContext context) {
    return Scaffold(
      // Couleur de fond de l'écran
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      // Autoriser la taille de l'écran à s'adapter
      resizeToAvoidBottomInset: true,
      // AppBar transparent avec un bouton de retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              color: Color(0xffF7F7F9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      // Corps de l'écran
      body: SafeArea(
        child: SingleChildScrollView(
          // Espacement horizontal et vertical
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            // Alignement des éléments
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Titre de l'écran
              Text(
                showLogin ? 'Se connecter' : 'Créer un compte',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              // Espacement
              const SizedBox(height: 40),
              // Champ de saisie de l'email
              _emailField(),
              // Espacement
              const SizedBox(height: 20),
              // Champ de saisie du mot de passe
              _passwordField(),
              // Espacement
              const SizedBox(height: 50),
              // Bouton de connexion ou d'inscription
              showLogin ? _loginButton(context) : _signupButton(context),
              // Espacement
              const SizedBox(height: 20),
              // Lien pour basculer entre la connexion et l'inscription
              _toggleLink(),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour le champ de saisie de l'email
  Widget _emailField() {
    return _inputField(
      label: 'Adresse Email',
      controller: _emailController,
      hintText: 'saisir@domaine.com',
    );
  }

  // Méthode pour le champ de saisie du mot de passe
  Widget _passwordField() {
    return _inputField(
      label: 'Mot de Passe',
      controller: _passwordController,
      obscureText: true,
    );
  }

  // Méthode pour le bouton de connexion
  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () async {
        // Appel à la méthode de connexion
        await AuthService().signin(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
      },
      child: const Text(
        "Se connecter",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Méthode pour le bouton d'inscription
  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () async {
        // Appel à la méthode d'inscription
        await AuthService().signup(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
      },
      child: const Text(
        "S'inscrire",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

// Méthode pour le lien de basculement entre la connexion et l'inscription
Widget _toggleLink() {
  return MouseRegion(
    cursor: SystemMouseCursors.click, // Changer le curseur en "doigt"
    child: GestureDetector(
      onTap: () {
        // Bascule entre la connexion et l'inscription
        setState(() {
          showLogin = !showLogin;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: showLogin
                  ? "Pas encore inscrit ? "
                  : "Vous avez déjà un compte ? ",
              style: const TextStyle(
                color: Color(0xff6A6A6A),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: showLogin ? "Créer un compte" : "Se connecter",
              style: const TextStyle(
                color: Color(0xff1A1D1E),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Méthode pour les champs de saisie génériques
  Widget _inputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label du champ de saisie
        Text(
          label,
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        // Espacement
        const SizedBox(height: 16),
        // Champ de saisie
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
