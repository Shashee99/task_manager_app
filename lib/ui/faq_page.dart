import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FAQ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "FAQ 1: How do I create a new task in the app?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "To create a new task, follow these steps\n"
                    "1. Open the app and go to the main task management screen.\n"
                    "2. Tap the 'Add Task' button or icon.\n"
                    "3. Fill in the task details, including the title, description, due date, and priority level.\n"
                    "4. Tap the 'Save' or 'Create' button to add the task.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "FAQ 2: How can I categorize my tasks for better organization?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You can categorize your tasks as follows:\n"
                    "1. When creating or editing a task, you can assign labels or tags to it.\n"
                    "2. You can create custom labels to suit your needs or select from predefined ones.\n"
                    "3. To filter tasks by category, use the filter option and select the desired label.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "FAQ 3: How do I set task reminders and notifications?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "To set task reminders and notifications:\n"
                    "1. When creating or editing a task, you can choose a due date and time.\n"
                    "2. Enable notifications for the task, and you'll receive reminders before the due date.\n"
                    "3. You can customize notification preferences in the app's settings.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "FAQ 4: How can I attach notes or files to my tasks?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You can add notes and attachments to tasks by:\n"
                    "1. Opening the task you want to add notes or attachments to.\n"
                    "2. Look for the 'Notes' or 'Attachments' section within the task details.\n"
                    "3. Tap 'Add Note' to add text notes or 'Add Attachment' to attach files or images.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "FAQ 5: How can I export and import my task data for data synchronization?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "To export and import task data for data synchronization:\n"
                    "1. Go to the app's settings or data management section.\n"
                    "2. Select the option for exporting the database to a file.\n"
                    "3. Save the exported file to a location of your choice (e.g., your device or cloud storage).\n"
                    "4. To import an existing database, choose the import option and select the database file you want to use.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
