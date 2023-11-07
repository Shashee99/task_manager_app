import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/models/task.dart';

class ExportImportPage extends StatefulWidget {
  const ExportImportPage({Key? key}) : super(key: key);

  @override
  State<ExportImportPage> createState() => _ExportImportPageState();
}

class _ExportImportPageState extends State<ExportImportPage> {
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Export/Import Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                "Export Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await exportTasksToJson();
                },
                child: const Text("Export Tasks"),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Import Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await importTasksFromJson();
                },
                child: const Text("Import Tasks"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportTasksToJson() async {
    var statusExternal = await Permission.manageExternalStorage.status;
    var statusStorage = await Permission.storage.status;
    if (!statusExternal.isGranted && !statusStorage.isGranted) {
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    } else if (!statusExternal.isGranted) {
      await Permission.manageExternalStorage.request();
    } else if (!statusStorage.isGranted) {
      await Permission.storage.request();
    } else {
      print("Permission Granted");
    }
    if (!statusExternal.isGranted && !statusStorage.isGranted) {
      Get.snackbar("Permission Denied",
          "Please allow permission to access external storage to export tasks.");
      return;
    }
    EasyLoading.show(status: "Exporting tasks...", dismissOnTap: true);
    final directory = await getDownloadFolderLocation();
    final filePath = await File("${directory}/tasks"
            "-${FirebaseAuth.instance.currentUser!.uid}"
            "-${DateTime.now().year}"
            "-${DateTime.now().month}"
            "-${DateTime.now().day}"
            "-${DateTime.now().hour}"
            "-${DateTime.now().minute}"
            ".json")
        .path;
    _taskController.getTasks();
    final tasks = _taskController.taskList;
    final jsonString = jsonEncode(tasks);
    await File(filePath).writeAsString(jsonString);
    EasyLoading.dismiss();
    Get.snackbar("Exported Tasks", "Successfully exported tasks.");
  }

  Future<void> importTasksFromJson() async {
    var statusExternal = await Permission.manageExternalStorage.status;
    var statusStorage = await Permission.storage.status;
    if (!statusExternal.isGranted && !statusStorage.isGranted) {
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    } else if (!statusExternal.isGranted) {
      await Permission.manageExternalStorage.request();
    } else if (!statusStorage.isGranted) {
      await Permission.storage.request();
    } else {
      print("Permission Granted");
    }
    if (!statusExternal.isGranted && !statusStorage.isGranted) {
      Get.snackbar("Permission Denied",
          "Please allow permission to access external storage to export tasks.");
      return;
    }
    EasyLoading.show(status: "Importing tasks...", dismissOnTap: true);
    final directory = await getDownloadFolderLocation();
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      initialDirectory: directory,
    );
    if (file == null) {
      return;
    }
    final jsonString = await File(file.paths.first ?? "").readAsString();
    final importedRawTasks = jsonDecode(jsonString);
    final importedTasks =
        await convertImportedTasksToListOfTasks(importedRawTasks);
    _taskController.getTasks();
    final currentTasks = _taskController.taskList;
    for (var task in currentTasks) {
      _taskController.deleteTask(task);
    }
    for (var task in importedTasks) {
      _taskController.addTaskToDb(task: task);
    }
    EasyLoading.dismiss();
    Get.snackbar("Imported Tasks", "Successfully imported tasks.");
  }

  Future<String> getDownloadFolderLocation() async {
    bool dirDownloadExists = true;
    var directory;
    if (Platform.isIOS) {
      directory = await path_provider.getDownloadsDirectory();
    } else {
      directory = "/storage/emulated/0/Download/";
      dirDownloadExists = await Directory(directory).exists();
      if (dirDownloadExists) {
        directory = "/storage/emulated/0/Download/";
      } else {
        directory = "/storage/emulated/0/Downloads/";
      }
    }
    return directory;
  }

  Future<List<Task>> convertImportedTasksToListOfTasks(
      final importedTasks) async {
    final List<Task> tasks = [];
    for (final importedTask in importedTasks) {
      final task = Task.fromJson(importedTask);
      tasks.add(task);
    }
    return tasks;
  }
}
