import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe Task qui représente une mission dans l'application de liste de tâches.
class Task {
  // Identifiant unique de la mission
  final String id;

  // Titre de la mission
  final String title;

  // État de la mission (complétée ou non)
  bool isCompleted;

  // Nouvelle propriété : Date de la mission
  final String date;

  // Nouvelle propriété : Lieu de la mission
  final String lieu;

  // Nouvelle propriété : Activités réalisées
  final String activitesRealisees;

  // Nouvelle propriété : Compétences acquises
  final String competencesAcquises;

  /// Constructeur de la classe Task avec les nouvelles propriétés.
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.lieu,
    required this.activitesRealisees,
    required this.competencesAcquises,
  });

  /// Méthode pour créer une instance de Task à partir d'un document Firestore.
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      date: data['date'] ?? '',
      lieu: data['lieu'] ?? '',
      activitesRealisees: data['activitesRealisees'] ?? '',
      competencesAcquises: data['competencesAcquises'] ?? '',
    );
  }

  /// Méthode pour convertir l'objet Task en format JSON.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'date': date,
      'lieu': lieu,
      'activitesRealisees': activitesRealisees,
      'competencesAcquises': competencesAcquises,
    };
  }
}
