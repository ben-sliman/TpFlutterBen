import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe `Task` qui représente une mission dans l'application de liste de tâches.
class Task {
  /// Identifiant unique de la mission.
  final String id;

  /// Titre de la mission.
  final String title;

  /// État de la mission : complétée (true) ou non (false).
  bool isCompleted;

  /// Date de la mission (stockée sous forme de chaîne de caractères).
  final String date;

  /// Lieu où s'est déroulée la mission.
  final String lieu;

  /// Description des activités réalisées pendant la mission.
  final String activitesRealisees;

  /// Description des compétences acquises lors de la mission.
  final String competencesAcquises;

  /// Constructeur de la classe `Task` qui permet d'initialiser toutes les propriétés.
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.lieu,
    required this.activitesRealisees,
    required this.competencesAcquises,
  });

  /// Méthode qui permet de créer une instance `Task` à partir d'un document Firestore.
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

  /// Méthode qui convertit une instance `Task` en format JSON
  /// pour pouvoir l'enregistrer dans Firestore.
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