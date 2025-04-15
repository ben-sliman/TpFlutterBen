import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/save_task.dart';
import '../../../models/task_model.dart';

/// Écran pour ajouter une nouvelle mission.
class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  final TextEditingController activitesController = TextEditingController();
  final TextEditingController competencesController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une mission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ de saisie pour le titre
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la mission',
                border: OutlineInputBorder(),
                hintText: 'Entrez le titre de votre mission...',
              ),
            ),
            const SizedBox(height: 16),

            // Champ de saisie pour la date avec sélection via un calendrier
            ListTile(
              title: Text(
                selectedDate != null
                    ? 'Date : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Sélectionnez une date',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Champ de saisie pour le lieu
            TextField(
              controller: lieuController,
              decoration: const InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
                hintText: 'Entrez le lieu de la mission...',
              ),
            ),
            const SizedBox(height: 16),

            // Champ de saisie pour les activités réalisées
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

            // Champ de saisie pour les compétences acquises
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

            // Bouton pour ajouter la mission
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isNotEmpty &&
                    selectedDate != null &&
                    lieuController.text.trim().isNotEmpty &&
                    activitesController.text.trim().isNotEmpty &&
                    competencesController.text.trim().isNotEmpty) {
                  try {
                    await context.read<SaveTask>().addTaskToFirestore(
                          Task(
                            id: '',
                            title: titleController.text.trim(),
                            isCompleted: false,
                            date: '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            lieu: lieuController.text.trim(),
                            activitesRealisees: activitesController.text.trim(),
                            competencesAcquises: competencesController.text.trim(),
                          ),
                        );
                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Erreur lors de l'ajout de la mission : $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Une erreur est survenue.")),
                    );
                  }
                } else {
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
