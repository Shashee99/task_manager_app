import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;
  final String scheduledDateTime;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
    required this.scheduledDateTime,
  });
}

NotificationWeekAndTime convertDateTimeToNotificationWeekAndTime(
    DateTime dateTime) {
  int dayOfTheWeek = dateTime.weekday;

  TimeOfDay timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  String scheduledDateTime = dateTime.toString();

  NotificationWeekAndTime notificationWeekAndTime = NotificationWeekAndTime(
    dayOfTheWeek: dayOfTheWeek,
    timeOfDay: timeOfDay,
    scheduledDateTime: scheduledDateTime,
  );

  return notificationWeekAndTime;
}
