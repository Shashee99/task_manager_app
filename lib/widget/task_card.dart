import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

import '../../models/task.dart';
import '../ui/size_config.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  // ignore: use_key_in_widget_constructors
  const TaskCard(this.task);

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(task.startDate);
    DateTime endDate = DateTime.parse(task.endDate);

    // String ymdStartDate = DateFormat('MM/d').format(startDate);
    String ymdEndDate = DateFormat('MM/dd/yyyy').format(endDate);

    // String hmStartDate = DateFormat('HH:mm aa').format(startDate);
    String hmEndDate = DateFormat('HH:mm').format(endDate);

    IconData selectedIcon;

    Map<String, Color> taskColor = {
      'High': Colors.red,
      'Normal': Colors.orange,
      'Low': Colors.green,
    };

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        child: Row(children: [
          // if(task.priority == 'Important'){
          //   selectedIcon = Icons.play_circle;
          // }
          // else if(){
          //
          // } else {
          //
          // },
          Container(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.play_circle,
              color: taskColor[task.priority],
              size: 40,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.black!.withOpacity(0.7), // T0D0 text
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  task.title,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Text(
                  task.note,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 15, color: Colors.black), // description
                  ),
                ),
                Text(
                  task.priority,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 15, color: Colors.black), // description
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        '$ymdEndDate',
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        "$hmEndDate",
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.black!.withOpacity(0.7), // T0D0 text
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.aboreto(
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
