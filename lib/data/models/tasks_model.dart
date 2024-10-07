class TasksModel {
  String? id;
  String? title;
  String? desc;
  String? deadline;
  String? priority;
  int? isCompleted;

  TasksModel({
    this.title,
    this.desc,
    this.deadline,
    this.priority,
    this.isCompleted,
    this.id,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) => TasksModel(
      title: json["title"],
      desc: json["desc"],
      deadline: json["deadline"],
      priority: json["priority"],
      isCompleted: json["isCompleted"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
        "deadline": deadline,
        "priority": priority,
        "isCompleted": isCompleted,
        "id": id
      };
}
