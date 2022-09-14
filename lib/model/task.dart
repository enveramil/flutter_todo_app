class Task {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  int? reminder;
  String? repeat;
  int? color;
  int? isCompleted;

  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.reminder,
    this.repeat,
    this.color,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    reminder = json['reminder'];
    repeat = json['repeat'];
    color = json['color'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['reminder'] = reminder;
    data['repeat'] = repeat;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
