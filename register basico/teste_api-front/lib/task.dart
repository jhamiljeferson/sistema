class TaskItem {
  final int id;
  final String title;
  final bool done;

  TaskItem({required this.id, required this.title, required this.done});

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(id: json['id'], title: json['title'], done: json['done']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}
