import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/save_task.dart';
import '../../../models/task_model.dart';

/// Écran permettant d'ajouter une nouvelle mission.
/// Utilise un StatefulWidget pour gérer l'état des champs de texte et la date sélectionnée.
class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  // Contrôleurs pour récupérer les textes des champs.
  final TextEditingController titleController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  final TextEditingController activitesController = TextEditingController();
  final TextEditingController competencesController = TextEditingController();

  // Variable pour stocker la date choisie par l'utilisateur.
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application avec un titre.
      appBar: AppBar(
        title: const Text('Ajouter une mission'),
      ),

      // Corps de la page avec padding.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ pour saisir le titre de la mission.
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la mission',
                border: OutlineInputBorder(),
                hintText: 'Entrez le titre de votre mission...',
              ),
            ),
            const SizedBox(height: 16),

            // Sélection de la date sous forme de ListTile avec icône calendrier.
            ListTile(
              title: Text(
                selectedDate != null
                    ? 'Date : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Sélectionnez une date',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  // Ouvre le sélecteur de date.
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025), // date minimale autorisée
                    lastDate: DateTime.now(),  // empêche de choisir une date future
                  );
                  if (pickedDate != null) {
                    // Met à jour l'état avec la date sélectionnée.
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Champ pour saisir le lieu.
            TextField(
              controller: lieuController,
              decoration: const InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
                hintText: 'Entrez le lieu de la mission...',
              ),
            ),
            const SizedBox(height: 16),

            // Champ multilignes pour décrire les activités réalisées.
            TextField(
              controller: activitesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Activités réalisées',
                border: OutlineInputBorder(),
                hintText: 'Décrivez les activités réalisées...',
              ),
            ),
            const SizedBox(height: 16),

            // Champ multilignes pour décrire les compétences acquises.
            TextField(
              controller: competencesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Compétences acquises',
                border: OutlineInputBorder(),
                hintText: 'Décrivez les compétences acquises...',
              ),
            ),
            const SizedBox(height: 20),

            // Bouton pour ajouter la mission à Firestore.
            ElevatedButton(
              onPressed: () async {
                // Vérification que tous les champs sont bien remplis.
                if (titleController.text.trim().isNotEmpty &&
                    selectedDate != null &&
                    lieuController.text.trim().isNotEmpty &&
                    activitesController.text.trim().isNotEmpty &&
                    competencesController.text.trim().isNotEmpty) {
                  try {
                    // Appel au provider pour sauvegarder la mission.
                    await context.read<SaveTask>().addTaskToFirestore(
                          Task(
                            id: '', // Firestore générera un ID automatiquement.
                            title: titleController.text.trim(),
                            isCompleted: false,
                            date: '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            lieu: lieuController.text.trim(),
                            activitesRealisees: activitesController.text.trim(),
                            competencesAcquises: competencesController.text.trim(),
                          ),
                        );
                    // Retour à la page précédente une fois la mission ajoutée.
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Gestion des erreurs d'enregistrement.
                    print("Erreur lors de l'ajout de la mission : $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Une erreur est survenue.")),
                    );
                  }
                } else {
                  // Alerte si des champs sont vides.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tous les champs sont obligatoires.')),
                  );
                }
              },
              child: const Text('Ajouter la mission'),
            ),
          ],
        ),
      ),
    );
  }
}