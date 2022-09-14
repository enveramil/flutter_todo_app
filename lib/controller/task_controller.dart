import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';

import '../model/task.dart';

class TaskController extends GetxController {
  // @override
  // void onReady() {
  //   super.onReady();
  // }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DbHelper.insert(task);
  }

  // get all data
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void isTaskCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }

  void delete(Task task) async {
    await DbHelper.delete(task);
    getTasks();
  }
}
