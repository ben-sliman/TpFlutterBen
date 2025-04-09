import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_stage/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_stage/models/save_task.dart';
import 'package:app_stage/pages/login/login_page.dart';
import 'package:app_stage/pages/add_todo.dart'; // Import de AddTodo
import 'package:app_stage/pages/todo_list.dart'; // Import de TodoList

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SaveTask()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // Configuration du thème
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system, // Respecte le thème du système (clair ou sombre)

      // Définition des routes
      routes: {
        '/': (context) => const Login(), // Page de connexion par défaut
        '/todo-list': (context) => const TodoList(), // Page des tâches
        '/add-todo-screen': (context) => const AddTodo(), // Page d'ajout
      },
    );
  }
}
