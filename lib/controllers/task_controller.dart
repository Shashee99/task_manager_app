import 'package:get/get.dart';

import '../db_service/firebase_services.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final taskList = <Task>[].obs;

  // add data to table
  Future<void> addTaskToDb({required Task task}) async {
    return await FirebaseService.insertData(task);
  }

  Future<void> updateTaskOnDb({required Task task}) async {
    return await FirebaseService.updateTask(task);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await FirebaseService.getTaskData();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  // delete data from table
  void deleteTask(Task task) async {
    await FirebaseService.deleteTaskFromArray(task);
    getTasks();
  }

  // update data int table
  void markTaskCompleted(Task task) async {
    await FirebaseService.updateTaskArray(task, task.toJson());
    getTasks();
  }
}
