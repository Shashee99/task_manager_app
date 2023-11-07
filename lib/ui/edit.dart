import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
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

class Edit extends StatefulWidget {
  const Edit({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TaskController _taskController = Get.find<TaskController>();

  final DateTime _selectedDate = DateTime.now();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(minutes: 5));

  late String _startTime = DateFormat('hh:mm a').format(_startDate).toString();
  late String _endTime = DateFormat('hh:mm a').format(_endDate).toString();

  late String _selectedValue = 'Low';

  XFile? imageFile = null;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _noteController.text = widget.task.note;
    _selectedValue = widget.task.priority;
    _startDate = DateTime.parse(widget.task.startDate);
    _endDate = DateTime.parse(widget.task.endDate);
    _startTime = DateFormat('hh:mm a').format(_startDate).toString();
    _endTime = DateFormat('hh:mm a').format(_endDate).toString();
    print(widget.task.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFF2F5FE),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              // MyTextField(
              //     title: "Title", hint: "", controller: _titleController),
              // MyTextField(
              //     title: "Notes", hint: "", controller: _noteController),
              InputField(
                title: "Task Title",
                hint: "Enter your title here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Task Description",
                  hint: "Enter description here.",
                  controller: _noteController),
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      MyTextField(
                        title: "Start Date",
                        hint: DateFormat('dd/MM/yyyy').format(_startDate),
                        widget: IconButton(
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getDateFromUser(isStartTime: true);
                          },
                        ),
                      ),
                      const SizedBox(
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
              const SizedBox(
                height: 40.0,
              ),
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
                          : widget.task.imageUrl == null
                              ? Image.network(
                                  "https://placehold.co/600x400/png?text=Add+Picture",
                                  fit: BoxFit.contain,
                                )
                              : StreamBuilder(
                                  stream: firebase_storage
                                      .FirebaseStorage.instance
                                      .ref(widget.task.imageUrl)
                                      .getDownloadURL()
                                      .asStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data.toString(),
                                        fit: BoxFit.contain,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Image.network(
                                        "https://placehold.co/600x400/png?text=Add+Picture",
                                        fit: BoxFit.contain,
                                      );
                                    } else {
                                      return const Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
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
                    label: widget.task.imageUrl == null
                        ? "Add Picture"
                        : "Replace Picture",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      label: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: MyButton(
                      label: "Save",
                      onTap: () {
                        _validateInputs();
                      },
                    ),
                  ),
                ],
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
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
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
    DateTime startDate = DateFormat('MM/dd/yyyy hh:mm a')
        .parse('${DateFormat.yMd().format(_startDate)} $_startTime');
    DateTime endDate = DateFormat('MM/dd/yyyy hh:mm a')
        .parse('${DateFormat.yMd().format(_endDate)} $_endTime');
    widget.task.title = _titleController.text;
    widget.task.note = _noteController.text;
    widget.task.priority = _selectedValue;
    widget.task.startDate = startDate.toString();
    widget.task.endDate = endDate.toString();
    if (imageFile != null) {
      try {
        print("Attemping to upload image");
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
        widget.task.imageUrl = refPath;

        cancelNotificationById(widget.task.notificationId);
        int notificationId = createUniqueId();
        widget.task.notificationId = notificationId;

        NotificationWeekAndTime notificationWeekAndTime =
            convertDateTimeToNotificationWeekAndTime(_endDate);
        await NotificationService.createTaskReminderNotification(
            notificationWeekAndTime,
            _titleController.text,
            _noteController.text,
            notificationId);

        _updateTaskOnDB();
        Get.back();
      } catch (e) {
        print(e);
        //show error toast
        Get.snackbar(
          "Error",
          "Error uploading image. ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      cancelNotificationById(widget.task.notificationId);
      int notificationId = createUniqueId();
      widget.task.notificationId = notificationId;
      NotificationWeekAndTime notificationWeekAndTime =
          convertDateTimeToNotificationWeekAndTime(_endDate);

      await NotificationService.createTaskReminderNotification(
          notificationWeekAndTime,
          _titleController.text,
          _noteController.text,
          notificationId);

      _updateTaskOnDB();
      Get.back();
    }
  }

  _updateTaskOnDB() async {
    await _taskController.updateTaskOnDb(task: widget.task);
    //show update toast
    Get.snackbar(
      "Updated",
      "Task updated successfully.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> cancelNotificationById(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }
}
