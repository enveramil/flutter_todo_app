import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utility/themes.dart';
import '../model/task.dart';

class TaskTile extends StatelessWidget {
  final Task? task;

  TaskTile(this.task);
  var inputEndTime = DateFormat("HH:mm").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    print(inputEndTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: task!.isCompleted == 1 ? HexColor('#2B9322') : _getBGClr(task?.color ?? 0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Görev: ${task?.title ?? ""}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                    ),
                    //int.parse(inputEndTime.toString().split(":")[0]),
                    //int.parse(inputEndTime.toString().split(":")[1]),
                    Icon(int.parse(task!.endTime.toString().split(":")[0]) ==
                                int.parse(inputEndTime.toString().split(":")[0]) &&
                            int.parse(task!.endTime.toString().split(":")[1]) >
                                int.parse(inputEndTime.toString().split(":")[1])
                        ? null
                        : Icons.done),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    Text(
                      "  ${task?.date}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "Açıklama: ${task?.description ?? ""}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "TAMAMLANDI" : "YAPILACAK",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.menu,
                size: 30,
                color: Get.isDarkMode ? Colors.white : Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return blueColor;
      case 1:
        return pinkColor;
      case 2:
        return yellowColor;
      default:
        return blueColor;
    }
  }
}
