import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utility/themes.dart';

class TaskNotificationPage extends StatelessWidget {
  const TaskNotificationPage({Key? key, required this.label}) : super(key: key);
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            )),
        title: Text(
          this.label.toString().split("|")[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.done,
              color: Colors.green,
              size: 200,
            ),
            Text(
              'Görev Süreniz Doldu',
              style: headingStyle,
            )
          ],
        ),
      ),
    );
  }
}
