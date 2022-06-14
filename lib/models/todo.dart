class Todo {
  final int? id;
  final String? title;
  final int taskId;
  final int isDone;

  Todo({this.id, this.title, required this.taskId, required this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'taskId': taskId,
      'isDone': isDone,
    };
  }
}
