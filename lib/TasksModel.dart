class TaskModel {
  final int? id;
  final String task;
  TaskModel({required this.task, this.id});

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      task: map['task'],
      id: map['id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'task': task,
    };
  }
}
