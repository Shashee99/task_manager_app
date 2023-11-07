import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<void> insertData(Task model) async {
    try {
      final collectionReference = fireStore.collection('users_tasks');
      final documentReference = collectionReference.doc(auth.currentUser!.uid);
      final subCollectionReference = documentReference.collection('tasks');

      final taskData = {
        'userId': model.userId,
        'task_title': model.title,
        'task_note': model.note,
        'start_date': model.startDate,
        'end_date': model.endDate,
        "image_url": model.imageUrl,
        'task_priority': model.priority,
        'is_completed': model.isCompleted,
        'notification_id': model.notificationId,
        'time_stamp': DateTime.now().toString(),
      };

      await subCollectionReference.add(taskData);
    } catch (e) {
      print('Error adding data to FireStore: $e');
      // Handle errors as needed
    }
  }

  static Future<List<Map<String, dynamic>>> getTaskData() async {
    try {
      final collectionReference = fireStore.collection('users_tasks');
      final documentReference = collectionReference.doc(auth.currentUser!.uid);
      final subCollectionReference = documentReference.collection('tasks');

      final querySnapshot = await subCollectionReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> taskData = [];

        for (final doc in querySnapshot.docs) {
          final data = doc.data();

          print(doc.id);
          taskData.add({
            'array_name': doc.id,
            'userId': data['userId'],
            'task_title': data['task_title'],
            'task_note': data['task_note'],
            'start_date': data['start_date'],
            'end_date': data['end_date'],
            'task_priority': data['task_priority'],
            'is_completed': data['is_completed'],
            'image_url': data['image_url'],
            'notification_id': data['notification_id'],
            'time_stamp': data['time_stamp'],
          });
        }

        return taskData;
      }

      return [];
    } catch (e) {
      print('Error fetching task data: $e');
      return [];
    }
  }

  static Future<void> deleteTaskFromArray(Task task) async {
    try {
      final collectionReference = fireStore.collection('users_tasks');
      final documentReference = collectionReference.doc(auth.currentUser!.uid);
      final subCollectionReference = documentReference
          .collection('tasks'); // Reference to the 'tasks' subCollection

      // Print the array name for debugging purposes
      print("Deleting task with ID: ${task.arrayName}");

      // Delete the task document from the subCollection
      await subCollectionReference.doc(task.arrayName).delete();
    } catch (e) {
      print('Error deleting task: $e');
      // Handle errors as needed
    }
  }

  static Future<void> updateTaskArray(
      Task task, Map<String, dynamic> updatedTaskData) async {
    try {
      final collectionReference = fireStore.collection('users_tasks');
      final documentReference = collectionReference.doc(auth.currentUser!.uid);
      final subCollectionReference = documentReference
          .collection('tasks'); // Reference to the 'tasks' subcollection

      // Use the task ID to identify the specific task document
      print(task.arrayName);
      final taskDocumentReference = subCollectionReference.doc(task.arrayName);

      // Update the task document in the subCollection
      await taskDocumentReference.update(updatedTaskData);
    } catch (e) {
      print('Error updating task: $e');
      // Handle errors as needed
    }
  }

  static Future<void> updateTask(Task task) async {
    try {
      final collectionReference = fireStore.collection('users_tasks');
      final documentReference = collectionReference.doc(auth.currentUser!.uid);
      final subCollectionReference = documentReference
          .collection('tasks'); // Reference to the 'tasks' subcollection

      // Use the task ID to identify the specific task document
      print(task.arrayName);
      final taskDocumentReference = subCollectionReference.doc(task.arrayName);

      // Update the task document in the subCollection
      await taskDocumentReference.update(task.toJson());
    } catch (e) {
      print('Error updating task: $e');
      // Handle errors as needed
    }
  }
}
