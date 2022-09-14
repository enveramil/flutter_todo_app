import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utility/themes.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap, required this.addTaskButtonColor})
      : super(key: key);
  final String label;
  final Function()? onTap;
  final Color addTaskButtonColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: addTaskButtonColor,
          side: BorderSide(
            style: BorderStyle.solid,
            color: Get.isDarkMode ? Colors.black : Colors.white,
            width: 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.20,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: FittedBox(
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
