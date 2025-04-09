import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/save_task.dart';
import '../../models/task_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final presentationController = TextEditingController();
    final objectifsController = TextEditingController();
    final difficultiesController = TextEditingController();
    final conclusionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport de Stage'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/add-todo-screen'),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Présentation de l’entreprise'),
              _buildMultilineField(presentationController, 'Décrivez l’entreprise ici...'),
              const SizedBox(height: 20),
              _buildSectionTitle('Objectifs du stage'),
              _buildMultilineField(objectifsController, 'Quels étaient les objectifs de votre stage ?'),
              const SizedBox(height: 20),
              _buildSectionTitle('Missions réalisées'),
              const SizedBox(height: 10),
              FutureBuilder(
                future: context.read<SaveTask>().fetchTasksFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)));
                  } else {
                    return Consumer<SaveTask>(
                      builder: (context, taskProvider, _) {
                        if (taskProvider.tasks.isEmpty) {
                          return const Text("Aucune tâche pour le moment.");
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                            ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: task.isCompleted,
                                          activeColor: task.isCompleted ? Colors.red : Colors.blue,
                                          onChanged: (_) => context.read<SaveTask>().toggleTaskCompletion(task),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (task.date.isNotEmpty) Text(' Date : ${task.date}'),
                                    if (task.lieu.isNotEmpty) Text(' Lieu : ${task.lieu}'),
                                    if (task.activitesRealisees.isNotEmpty) Text(' Activités : ${task.activitesRealisees}'),
                                    if (task.competencesAcquises.isNotEmpty) Text(' Compétences : ${task.competencesAcquises}'),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editTaskDialog(context, task),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _confirmDelete(context, task),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Difficultés rencontrées'),
              _buildMultilineField(difficultiesController, 'Quelles difficultés avez-vous rencontrées ?'),
              const SizedBox(height: 20),
              _buildSectionTitle('Conclusion'),
              _buildMultilineField(conclusionController, 'Rédigez votre conclusion ici...'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final isValid = [
                    presentationController.text.trim(),
                    objectifsController.text.trim(),
                    difficultiesController.text.trim(),
                    conclusionController.text.trim(),
                  ].every((text) => text.isNotEmpty);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isValid ? 'Rapport sauvegardé avec succès !' : 'Veuillez remplir toutes les sections.',
                      ),
                    ),
                  );
                },
                child: const Text('Sauvegarder le rapport'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  Widget _buildMultilineField(TextEditingController controller, String hint) => TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      );

  void _editTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier la tâche"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Titre de la tâche', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                await context.read<SaveTask>().editTask(task.id, newTitle);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Le titre ne peut pas être vide.")),
                );
              }
            },
            child: const Text("Modifier"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la tâche"),
        content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              context.read<SaveTask>().removeTaskFromFirestore(task.id);
              Navigator.of(context).pop();
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
