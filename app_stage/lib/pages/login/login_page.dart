import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_stage/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// Classe pour gérer l'état de l'écran de connexion
class _LoginState extends State<Login> {
  bool showLogin = true; // Détermine si l'écran doit afficher la connexion ou l'inscription

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      resizeToAvoidBottomInset: true,

      // AppBar sans bouton retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false, // Supprime le bouton flèche retour
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              const SizedBox(height: 40),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 50),
              showLogin ? _loginButton(context) : _signupButton(context),
              const SizedBox(height: 20),
              _toggleLink(),
            ],
          ),
        ),
      ),
    );
  }

  // Champ de saisie de l'email
  Widget _emailField() {
    return _inputField(
      label: 'Adresse Email',
      controller: _emailController,
      hintText: 'saisir@domaine.com',
    );
  }

  // Champ de saisie du mot de passe
  Widget _passwordField() {
    return _inputField(
      label: 'Mot de Passe',
      controller: _passwordController,
      obscureText: true,
    );
  }

  // Bouton de connexion
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

  // Bouton d'inscription
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

  // Lien pour basculer entre la connexion et l'inscription
  Widget _toggleLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
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

  // Champs de saisie génériques
  Widget _inputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 16),
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
