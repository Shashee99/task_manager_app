import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../notification_service/notification.dart';
import '../notification_service/notification_helper.dart';
import '../widget/button.dart';
import '../widget/input_field.dart';
import '../widget/textField.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TaskController _taskController = Get.find<TaskController>();

  final DateTime _selectedDate = DateTime.now();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(minutes: 5));

  late String _startTime = DateFormat('hh:mm a').format(_startDate).toString();
  late String _endTime = DateFormat('hh:mm a').format(_endDate).toString();

  late String _selectedValue = 'Low';

  XFile? imageFile = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xFFF2F5FE),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              InputField(
                title: "Task Title",
                hint: "Enter your title here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Task Description",
                  hint: "Enter description here.",
                  controller: _noteController),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                  });
                },
                items: <String>['Low', 'Normal', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      MyTextField(
                        title: "Start Date",
                        hint: DateFormat('dd/MM/yyyy').format(_startDate),
                        widget: IconButton(
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getDateFromUser(isStartTime: true);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyTextField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.punch_clock_sharp,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {});
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      title: "End Date",
                      hint: DateFormat('dd/MM/yyyy').format(_endDate),
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.calendar_month,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getDateFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyTextField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.punch_clock_rounded,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: imageFile != null
                          ? Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              "https://placehold.co/600x400/png?text=Add+Picture",
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      print(image!.path);
                      if (image == null) return;
                      setState(() {
                        imageFile = image;
                      });
                    },
                    label: "Add Picture",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                label: "Create Task",
                onTap: () {
                  _validateInputs();
                },
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser({required bool isStartTime}) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: isStartTime ? _startDate : _endDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    if (pickedDate == null) return;

    if (isStartTime == true) {
      setState(() {
        _startDate = pickedDate;
      });
    } else {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: isStartTime ? _startDate.hour : _endDate.hour,
          minute: isStartTime ? _startDate.minute : _endDate.minute),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      context: context,
      useRootNavigator: false,
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker(isStartTime: isStartTime);
    String _formatedTime = _pickedTime.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _validateInputs() async {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      print('came here');
      print(_titleController.text);
      print(_noteController.text);
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_startDate.isAfter(_endDate)) {
      print('came here 1');
      Get.snackbar(
        "Invalid datetime",
        "Start date cannot be after end date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    DateTime startDate = DateFormat('MM/dd/yyyy HH:mm')
        .parse('${DateFormat.yMd().format(_startDate)} $_startTime');
    DateTime endDate = DateFormat('MM/dd/yyyy HH:mm')
        .parse('${DateFormat.yMd().format(_endDate)} $_endTime');

    int notificationId = createUniqueId();
    NotificationWeekAndTime notificationWeekAndTime =
        convertDateTimeToNotificationWeekAndTime(endDate);

    Task newTask = Task(
        userId: FirebaseAuth.instance.currentUser!.uid,
        note: _noteController.text,
        title: _titleController.text,
        startDate: startDate.toString(),
        endDate: endDate.toString(),
        isCompleted: 0,
        priority: _selectedValue,
        notificationId: notificationId);

    if (imageFile != null) {
      try {
        print("Attempting to upload image");
        var response = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child(
              'tasks-images/${FirebaseAuth.instance.currentUser!.uid}/${UniqueKey().toString()}.${imageFile!.name.split([
                "."
              ].last)}',
            )
            .putFile(
              File(imageFile!.path),
            );
        var refPath = response.ref.fullPath;
        newTask.imageUrl = refPath;
        await NotificationService.createTaskReminderNotification(
            notificationWeekAndTime,
            _titleController.text,
            _noteController.text,
            notificationId);

        _addTaskToDB(newTask);
        Get.back();
      } catch (e) {
        Get.snackbar(
          "Error",
          "Error uploading image. ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      await NotificationService.createTaskReminderNotification(
          notificationWeekAndTime,
          _titleController.text,
          _noteController.text,
          notificationId);
      _addTaskToDB(newTask);
      Get.back();
    }
  }

  _addTaskToDB(Task newTask) async {
    await _taskController.addTaskToDb(
      task: newTask,
    );
  }
}
