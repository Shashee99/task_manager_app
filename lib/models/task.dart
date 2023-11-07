class Task {
  late String? id;
  late String userId;
  late String title;
  late String note;
  late int isCompleted;
  late String startDate;
  late String endDate;
  late String priority;
  late int remind;
  late String repeat;
  late String? arrayName;
  late String? imageUrl;
  late int notificationId;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.notificationId,
  }) {
    this.imageUrl = null;
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arrayName = json['array_name'];
    userId = json['userId'];
    title = json['task_title'];
    note = json['task_note'];
    isCompleted = json['is_completed'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    priority = json['task_priority'];
    imageUrl = json['image_url'];
    notificationId = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['array_name'] = arrayName;
    data['userId'] = userId;
    data['task_title'] = title;
    data['task_note'] = note;
    data['is_completed'] = isCompleted;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['task_priority'] = priority;
    data['image_url'] = imageUrl;
    data['notification_id'] = notificationId;
    return data;
  }
}
