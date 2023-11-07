import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/ui/edit.dart';
import 'package:task_manager/ui/size_config.dart';
import 'package:task_manager/ui/theme.dart';
import 'package:task_manager/widget/task_card.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'create_task.dart';
import 'nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _taskController = Get.put(TaskController());
  final DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  late Task task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTask(),
                ),
              ).then((value) => setState(() {
                    _taskController.getTasks();
                  }));
              _taskController.getTasks();
            }),
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text(
            'TASKPULSE',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: const Color(0xFFF2F5FE),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchTasks(_taskController.taskList),
                );
              },
              color: Colors.black,
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Pending",
              ),
              Tab(
                text: "Completed",
              ),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  //First tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        _addTaskBar(context),
                        const SizedBox(
                          height: 12,
                        ),
                        _showTasks(),
                      ],
                    ),
                  ),
                  //Second Tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        _addTaskBar(context),
                        const SizedBox(
                          height: 12,
                        ),
                        _showPendingTasks(),
                      ],
                    ),
                  ),
                  //Third Tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        _addTaskBar(context),
                        const SizedBox(
                          height: 12,
                        ),
                        _showCompletedTasks(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addTaskBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        bool isEmpty = true;

        if (_taskController.taskList.isNotEmpty) {
          isEmpty = false;
        }

        if (isEmpty) return _noTaskMsg();

        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              Task task = _taskController.taskList[index];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskCard(task)),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  _showPendingTasks() {
    return Expanded(
      child: Obx(
        () {
          List<Task> pendingList = [];

          for (var element in _taskController.taskList) {
            if (element.isCompleted == 0) {
              pendingList.add(element);
            }
          }

          bool isEmpty = true;

          if (pendingList.isNotEmpty) {
            isEmpty = false;
          }

          if (isEmpty) return _noTaskMsg();

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              Task task = pendingList[index];
              // notifyHelper.scheduledNotification(task);
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskCard(task)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showCompletedTasks() {
    return Expanded(
      child: Obx(
        () {
          List<Task> completedList = [];

          for (var element in _taskController.taskList) {
            if (element.isCompleted == 1) {
              completedList.add(element);
            }
          }
          bool isEmpty = true;

          if (completedList.isNotEmpty) {
            isEmpty = false;
          }
          if (isEmpty) return _noTaskMsg();

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: completedList.length,
            itemBuilder: (context, index) {
              Task task = completedList[index];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBottomSheet(context, task);
                          },
                          child: TaskCard(task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
                textAlign: TextAlign.center,
                style: subTitleTextStle,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        )),
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.20
            : SizeConfig.screenHeight * 0.32,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            task.isCompleted == 1
                ? Container(
                    height: 20,
                  )
                : const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      task.isCompleted = 1;
                      _taskController.markTaskCompleted(task);
                      Get.back();
                    },
                    clr: blue,
                  ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheetButton(
                    label: "Edit Task",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Edit(task: task),
                        ),
                      );
                    },
                    clr: successClr,
                  ),
            _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: darktBlu,
            ),
            const SizedBox(
              height: 15,
            ),
            _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      required Function onTap,
      Color? clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? titleTextStle
              : titleTextStle.copyWith(color: Colors.white),
        )),
      ),
    );
  }
}

class SearchTasks extends SearchDelegate<Task> {
  final List<Task> tasks;
  final _taskController = Get.put(TaskController());

  SearchTasks(this.tasks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(
          context,
          Task(
            notificationId: 0,
            title: '',
            startDate: '',
            endDate: '',
            isCompleted: 0,
            id: '',
            note: '',
            priority: '',
            userId: '',
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: TaskCard(filteredTasks[index]),
          onTap: () {
            showBottomSheet(context, filteredTasks[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text('Search for tasks'),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.24
            : SizeConfig.screenHeight * 0.32,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      task.isCompleted = 1;
                      _taskController.markTaskCompleted(task);
                      Get.back();
                    },
                    clr: blue,
                  ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheetButton(
                    label: "Edit Task",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Edit(task: task),
                        ),
                      );
                    },
                    clr: successClr,
                  ),
            _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: darktBlu,
            ),
            const SizedBox(
              height: 15,
            ),
            _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      required Function onTap,
      Color? clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleTextStle
                : titleTextStle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
