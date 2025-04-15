import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class SaveTask extends ChangeNotifier {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('todo_app');

  List<Task> tasks = [];

  Future<void> fetchTasksFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await _taskCollection.get();
      tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des tâches : $e");
    }
  }

  Future<void> addTaskToFirestore(Task task) async {
    try {
      await _taskCollection.add(task.toJson());
      await fetchTasksFromFirestore();
    } catch (e) {
      print("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  /// Modifie **tous les champs** d'une tâche existante dans Firestore.
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
      await fetchTasksFromFirestore();
    } catch (e) {
      print("Erreur lors de la mise à jour de la tâche : $e");
    }
  }

  Future<void> removeTaskFromFirestore(String id) async {
    try {
      await _taskCollection.doc(id).delete();
      await fetchTasksFromFirestore();
    } catch (e) {
      print("Erreur lors de la suppression de la tâche : $e");
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      task.isCompleted = !task.isCompleted;
      await _taskCollection.doc(task.id).update(task.toJson());
      await fetchTasksFromFirestore();
    } catch (e) {
      print("Erreur lors du changement d'état de la tâche : $e");
    }
  }
}
