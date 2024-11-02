
 class TodoModel {
  bool? status;
  int? responseCode;
  String? message;
  Todo? todo;

  TodoModel({
    this.status,
    this.responseCode,
    this.message,
    this.todo,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      status: json['success'] as bool?,
      responseCode: json['code'] as int?,
      message: json['message'] as String?,
      todo: json['data'] != null ? Todo.fromJson(json['data']) : null,
    );
  }
}

class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String? token; 

  Todo({
    required this.id,
    required this.title,
    required this.description,
     this.completed=false,
    this.token, 
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      completed: json['is_completed'],
      token: json['token'], // Make sure this is present in your JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'is_completed': completed,
      'token': token, // Include token in JSON output
    };
  }
}
