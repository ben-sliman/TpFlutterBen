import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../models/save_task.dart';
import '../../../models/task_model.dart';
import '../../services/auth_service.dart';

// Widget principal qui gère l'affichage du rapport de stage.
class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    // Contrôleurs pour récupérer les textes tapés par l'utilisateur.
    final presentationController = TextEditingController();
    final objectifsController = TextEditingController();
    final difficultiesController = TextEditingController();
    final conclusionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport de Stage'),
        actions: [
          // Bouton de déconnexion avec une boîte de confirmation.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Déconnexion"),
                  content: const Text("Voulez-vous vous déconnecter ?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Déconnexion"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await AuthService().signout(context: context);
              }
            },
          ),
        ],
      ),

      // Bouton flottant pour ajouter une nouvelle mission.
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/add-todo-screen'),
        child: const Icon(Icons.add),
      ),

      // Contenu principal de la page.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section présentation de l'entreprise.
              _buildSectionTitle("Présentation de l'entreprise"),
              _buildMultilineField(presentationController, 'Décrivez l’entreprise ici...'),
              const SizedBox(height: 20),

              // Section objectifs du stage.
              _buildSectionTitle('Objectifs du stage'),
              _buildMultilineField(objectifsController, 'Quels étaient les objectifs de votre stage ?'),
              const SizedBox(height: 20),

              // Section missions réalisées (données dynamiques Firestore).
              _buildSectionTitle('Missions réalisées'),
              const SizedBox(height: 10),
              FutureBuilder(
                future: context.read<SaveTask>().fetchTasksFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erreur : ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
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
                                    // Affiche le titre de la tâche.
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
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Affiche les détails de la tâche s'ils existent.
                                    if (task.date.isNotEmpty) Text(' Date : ${task.date}'),
                                    if (task.lieu.isNotEmpty) Text(' Lieu : ${task.lieu}'),
                                    if (task.activitesRealisees.isNotEmpty) Text(' Activités : ${task.activitesRealisees}'),
                                    if (task.competencesAcquises.isNotEmpty) Text(' Compétences : ${task.competencesAcquises}'),
                                    const SizedBox(height: 8),

                                    // Boutons pour modifier ou supprimer la tâche.
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

              // Section difficultés rencontrées.
              _buildSectionTitle('Difficultés rencontrées'),
              _buildMultilineField(difficultiesController, 'Quelles difficultés avez-vous rencontrées ?'),
              const SizedBox(height: 20),

              // Section conclusion.
              _buildSectionTitle('Conclusion'),
              _buildMultilineField(conclusionController, 'Rédigez votre conclusion ici...'),
              const SizedBox(height: 20),

              // Bouton pour générer le PDF final du rapport.
              ElevatedButton(
                onPressed: () => _generatePDF(
                  context,
                  presentationController.text,
                  objectifsController.text,
                  difficultiesController.text,
                  conclusionController.text
                ),
                child: const Text('Convertir en PDF'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher un titre de section.
  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  // Fonction réutilisable pour les champs de texte multilignes.
  Widget _buildMultilineField(TextEditingController controller, String hint) => TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      );

  // Fenêtre de modification d'une tâche existante.
  void _editTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final dateController = TextEditingController(text: task.date);
    final lieuController = TextEditingController(text: task.lieu);
    final activitesController = TextEditingController(text: task.activitesRealisees);
    final competencesController = TextEditingController(text: task.competencesAcquises);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la mission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMultilineField(titleController, 'Titre'),
              const SizedBox(height: 10),
              // Sélecteur de date.
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Cache le clavier.
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    dateController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildMultilineField(lieuController, 'Lieu'),
              _buildMultilineField(activitesController, 'Activités réalisées'),
              _buildMultilineField(competencesController, 'Compétences acquises'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Annuler")),
            TextButton(
              onPressed: () async {
                // Validation : tous les champs doivent être remplis.
                if ([titleController, dateController, lieuController, activitesController, competencesController]
                    .every((controller) => controller.text.trim().isNotEmpty)) {
                  await context.read<SaveTask>().editTask(
                        task.id,
                        titleController.text.trim(),
                        dateController.text.trim(),
                        lieuController.text.trim(),
                        activitesController.text.trim(),
                        competencesController.text.trim(),
                      );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tous les champs doivent être remplis.")),
                  );
                }
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  // Fenêtre de confirmation avant suppression d'une tâche.
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

  // Génération du PDF contenant tout le rapport de stage.
  Future<void> _generatePDF(BuildContext context, String presentation, String objectifs, String difficultes, String conclusion) async {
    final pdf = pw.Document();
    final tasks = context.read<SaveTask>().tasks;

    pw.Widget sectionTitle(String title) => pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
        decoration: pw.TextDecoration.underline,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Rapport de Stage',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
          sectionTitle("Présentation de l'entreprise"),
          pw.SizedBox(height: 5),
          pw.Paragraph(text: presentation),

          pw.SizedBox(height: 15),
          sectionTitle('Objectifs du stage'),
          pw.SizedBox(height: 5),
          pw.Paragraph(text: objectifs),

          pw.SizedBox(height: 15),
          sectionTitle('Missions Réalisées'),
          pw.SizedBox(height: 5),
          if (tasks.isEmpty)
            pw.Text('Aucune tâche pour le moment.')
          else
            pw.Column(
              children: tasks.map((task) => pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('-> ${task.title}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    if (task.date.isNotEmpty) pw.Text('Date : ${task.date}'),
                    if (task.lieu.isNotEmpty) pw.Text('Lieu : ${task.lieu}'),
                    if (task.activitesRealisees.isNotEmpty) pw.Text('Activités : ${task.activitesRealisees}'),
                    if (task.competencesAcquises.isNotEmpty) pw.Text('Compétences : ${task.competencesAcquises}'),
                  ],
                ),
              )).toList(),
            ),

          pw.SizedBox(height: 15),
          sectionTitle('Difficultés rencontrées'),
          pw.SizedBox(height: 5),
          pw.Paragraph(text: difficultes),

          pw.SizedBox(height: 15),
          sectionTitle('Conclusion'),
          pw.SizedBox(height: 5),
          pw.Paragraph(text: conclusion),
        ],
      ),
    );

    // Affiche la prévisualisation du PDF.
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}