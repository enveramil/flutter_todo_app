import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utility/themes.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({Key? key, required this.title, required this.hintText, this.controller, this.widget})
      : super(key: key);
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 90,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Get.isDarkMode ? Colors.white : Colors.grey, width: 3.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  minLines: 3,
                  maxLines: 5,
                  cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.black,
                  textInputAction: TextInputAction.next,
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: hintText,
                    hintStyle: titleStyle,
                    fillColor: Colors.black,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0,
                    )),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0,
                    )),
                  ),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
