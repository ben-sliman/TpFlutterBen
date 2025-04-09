// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

/// Classe SaveTask qui gère les tâches dans l'application de liste de tâches.
/// Elle étend ChangeNotifier pour notifier les widgets dépendants lorsqu'elle subit des modifications.
class SaveTask extends ChangeNotifier {
  // Référence à la collection de tâches dans Firestore
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('todo_app');

  // Liste locale des tâches
  List<Task> tasks = [];

  /// Récupère toutes les tâches depuis Firestore et les stocke dans la liste locale.
  Future<void> fetchTasksFromFirestore() async {
    try {
      // Récupération des tâches depuis Firestore
      final QuerySnapshot snapshot = await _taskCollection.get();
      // Conversion des tâches en liste de Task
      tasks = snapshot.docs.map((doc) {
        return Task.fromFirestore(doc);
      }).toList();
      // Notification des widgets dépendants
      notifyListeners();
    } catch (e) {
      // Gestion des erreurs
      print("Erreur lors de la récupération des tâches : $e");
    }
  }

  /// Ajoute une nouvelle tâche à Firestore et synchronise la liste locale.
  /// @param task La tâche à ajouter
  Future<void> addTaskToFirestore(Task task) async {
    try {
      // Ajout de la tâche à Firestore
      await _taskCollection.add(task.toJson());
      // Synchronisation de la liste locale
      await fetchTasksFromFirestore();
    } catch (e) {
      // Gestion des erreurs
      print("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  /// Modifie une tâche existante dans Firestore et synchronise la liste locale.
  /// @param id L'identifiant de la tâche à modifier
  /// @param newTitle Le nouveau titre de la tâche
  Future<void> editTask(String id, String newTitle) async {
    try {
      // Modification de la tâche dans Firestore
      await _taskCollection.doc(id).update({'title': newTitle});
      // Synchronisation de la liste locale
      await fetchTasksFromFirestore();
    } catch (e) {
      // Gestion des erreurs
      print("Erreur lors de la mise à jour de la tâche : $e");
    }
  }

  /// Supprime une tâche de Firestore et synchronise la liste locale.
  /// @param id L'identifiant de la tâche à supprimer
  Future<void> removeTaskFromFirestore(String id) async {
    try {
      // Suppression de la tâche de Firestore
      await _taskCollection.doc(id).delete();
      // Synchronisation de la liste locale
      await fetchTasksFromFirestore();
    } catch (e) {
      // Gestion des erreurs
      print("Erreur lors de la suppression de la tâche : $e");
    }
  }

  /// Bascule l'état "complété" d'une tâche et synchronise la liste locale.
  /// @param task La tâche dont l'état doit être modifié
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      // Inversion de l'état de la tâche
      task.isCompleted = !task.isCompleted;
      // Mise à jour de la tâche dans Firestore
      await _taskCollection.doc(task.id).update(task.toJson());
      // Synchronisation de la liste locale
      await fetchTasksFromFirestore();
    } catch (e) {
      // Gestion des erreurs
      print("Erreur lors du changement d'état de la tâche : $e");
    }
  }
}