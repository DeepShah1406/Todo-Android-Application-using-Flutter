class Task {
  final String id;
  final String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});

  void toggleCompleted() {
    completed = !completed;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    completed: json['completed'] as bool,
  );
}