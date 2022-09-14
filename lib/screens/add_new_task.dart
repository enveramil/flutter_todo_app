import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/utility/themes.dart';
import 'package:todo_app/widgets/button.dart';
import 'package:todo_app/widgets/custom_input_field.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({Key? key}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final Color selectionColor = HexColor('990000');
  final Color buttonColor = HexColor('6F217A');

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat?.Hm('tr').format(DateTime.now().toLocal()).toString();
  String _endTime = "09:30";
  int _selectRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectRepeat = "Yalnızca seçilen tarih";
  List<String> repeatList = [
    "Yalnızca seçilen tarih",
    "Her gün",
  ];

  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yeni Görev Ekle',
                style: headingStyle,
              ),
              CustomInputField(
                title: 'Görev Başlığı',
                hintText: 'Görev başlığınızı bu alana yazınız...',
                controller: _titleController,
              ),
              CustomInputField(
                title: 'Görev Açıklaması',
                hintText: 'Görev açıklamanızı bu alana yazınız...',
                controller: _descriptionController,
              ),
              CustomInputField(
                title: 'Tarih',
                hintText: DateFormat?.yMd('tr').format(_selectedDate),
                widget: IconButton(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),

              Row(
                children: [
                  Expanded(
                      child: CustomInputField(
                    title: 'Başlangıç Zamanı',
                    hintText: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[400],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomInputField(
                    title: 'Bitiş Zamanı',
                    hintText: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[400],
                      ),
                    ),
                  )),
                ],
              ),

              // CustomInputField(
              //   title: 'Hatırlatıcı',
              //   hintText: '$_selectRemind dakika daha erken',
              //   widget: DropdownButton(
              //     icon: const Icon(
              //       Icons.keyboard_arrow_down,
              //       color: Colors.grey,
              //     ),
              //     iconSize: 32,
              //     elevation: 4,
              //     style: subTitleStyle,
              //     underline: Container(
              //       height: 0,
              //     ),
              //     items: remindList.map<DropdownMenuItem<String>>((int value) {
              //       return DropdownMenuItem<String>(value: value.toString(), child: Text(value.toString()));
              //     }).toList(),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         _selectRemind = int.parse(newValue!);
              //       });
              //     },
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    title: 'Tekrar Süresi',
                    hintText: '$_selectRepeat ',
                    widget: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      underline: Container(
                        height: 0,
                      ),
                      items: repeatList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectRepeat = newValue!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.perm_device_information),
                        Expanded(
                          child: Text(
                            'Yalnızca seçilen tarih gün bittiğinde görünmez. Görevlerinizi gününde yerine getirmeniz beklenir.',
                            style: informationTextStyle,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                      label: 'Görev Oluştur',
                      onTap: () => _validationAllField(),
                      addTaskButtonColor: Get.isDarkMode ? buttonColor : buttonColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Renk Seç',
          style: titleStyle,
        ),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                          ? pinkColor
                          : yellowColor,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _validationAllField() {
    if (_titleController.text.toString().isNotEmpty && _descriptionController.text.toString().isNotEmpty) {
      if (_titleController.text.isNumericOnly == true && _descriptionController.text.isNumericOnly == true) {
        Get.snackbar(
          'Wrong',
          'All inputs are number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkColor,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: pinkColor,
          ),
        );
      } else {
        _addTaskToDb();
        Get.back();
      }
    } else if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All Field are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkColor,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: pinkColor,
        ),
      );
    }
  }

  _addTaskToDb() async {
    var value = await _taskController.addTask(
      task: Task(
        title: _titleController.text.toString(),
        description: _descriptionController.text.toString(),
        date: DateFormat.yMd('tr').format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        reminder: _selectRemind,
        repeat: _selectRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("Task id: $value");
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/user.png"),
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2023),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();

    // convert to string
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled.");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
