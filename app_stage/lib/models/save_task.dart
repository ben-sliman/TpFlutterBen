import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

/// Classe qui gère la logique de sauvegarde, modification et suppression
/// des tâches dans Firestore, en utilisant le modèle Task.
/// Elle étend ChangeNotifier pour permettre à l'UI de réagir aux changements.
class SaveTask extends ChangeNotifier {

  /// Référence à la collection 'todo_app' dans Firestore.
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('todo_app');

  /// Liste locale des tâches récupérées depuis Firestore.
  List<Task> tasks = [];

  /// Récupère toutes les tâches stockées dans Firestore
  /// et met à jour la liste locale `tasks`.
  Future<void> fetchTasksFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await _taskCollection.get();
      tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      notifyListeners(); // Notifie les widgets écoutant ce modèle.
    } catch (e) {
      print("Erreur lors de la récupération des tâches : $e");
    }
  }

  /// Ajoute une nouvelle tâche dans Firestore.
  /// Une fois ajoutée, la liste locale est mise à jour.
  Future<void> addTaskToFirestore(Task task) async {
    try {
      await _taskCollection.add(task.toJson()); // Convertit l'objet Task en JSON.
      await fetchTasksFromFirestore(); // Rafraîchit la liste après ajout.
    } catch (e) {
      print("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  /// Met à jour **tous les champs** d'une tâche existante dans Firestore.
  /// [id] est l'identifiant du document à modifier.
  Future<void> editTask(
    String id,
    String newTitle,
    String newDate,
    String newLieu,
    String newActivites,
    String newCompetences,
  ) async {
    try {
      await _taskCollection.doc(id).update({
        'title': newTitle,
        'date': newDate,
        'lieu': newLieu,
        'activitesRealisees': newActivites,
        'competencesAcquises': newCompetences,
      });
      await fetchTasksFromFirestore(); // Rafraîchit la liste après modification.
    } catch (e) {
      print("Erreur lors de la mise à jour de la tâche : $e");
    }
  }

  /// Supprime une tâche de Firestore via son identifiant.
  /// Rafraîchit la liste locale après suppression.
  Future<void> removeTaskFromFirestore(String id) async {
    try {
      await _taskCollection.doc(id).delete();
      await fetchTasksFromFirestore();
    } catch (e) {
      print("Erreur lors de la suppression de la tâche : $e");
    }
  }

  /// Change l'état d'achèvement (isCompleted) d'une tâche :
  /// coche ou décoche, puis met à jour Firestore et la liste locale.
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      task.isCompleted = !task.isCompleted; // Inverse l'état.
      await _taskCollection.doc(task.id).update(task.toJson());
      await fetchTasksFromFirestore(); // Rafraîchit la liste après modification.
    } catch (e) {
      print("Erreur lors du changement d'état de la tâche : $e");
    }
  }
}