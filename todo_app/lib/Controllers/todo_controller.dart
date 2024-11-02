import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Models/To_do.dart';
import 'package:todo_app/Models/repository/api_repository.dart';
import 'package:todo_app/constants/app_url.dart';
import 'package:todo_app/constants/global_variables.dart';
import 'package:todo_app/constants/routes/routes.dart';
import 'package:todo_app/constants/service/hive_service.dart';
import 'package:todo_app/constants/show_toast.dart';

class TodoProvider with ChangeNotifier {
  final ApiRepsitory repo = ApiRepsitory();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  TodoProvider() {
    fetchTodos();
  }

  bool _todoloading = false;
  bool get todoloading => _todoloading;

  setLoading(bool value) {
    _todoloading = value;
    notifyListeners();
  }

  final String apiUrl = AppUrl.baseUrl;

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?page=1&limit=20'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        _todos = items.map((json) => Todo.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(BuildContext context, Todo todo) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setLoading(true);
    dynamic data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_completed': todo.completed,
    };

    try {
      await repo
          .todoApi(
        data: data,
        url: AppUrl.addUrl,
        context: context,
      )
          .then(
        (value) async {
          setLoading(false);

          if (value.status == true) {
            _todos.add(value.todo!);
            notifyListeners();
           

            await HiveService.saveUserInfo(value.todo!); // Save offline
            checkVerificationStatus(context);
            clear(); // Clear input fields
          } else {
            showToast(message: value.message ?? 'Failed to add todo');
          }
        },
      );
    } catch (error) {
      showToast(message: 'Failed to add todo: ${error.toString()}');
    } finally {
      setLoading(false);
    }
  }

  // session management
  Future<void> checkVerificationStatus(context) async {
    String status = await HiveService.checkVerificationStatus();
    if (kDebugMode) {
      print('Checking Statucs ======== > $status');
    }
    if (status.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ScreenRoutes.todo,
        (route) => false,
      );
    } else if (status == 'Verified') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ScreenRoutes.home,
        (route) => false,
      );
    } else {
      if (kDebugMode) {
        loger.f("something went wrong===========> $status");
      }
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (todoIndex == -1) return;

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${updatedTodo.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedTodo.toJson()),
      );

      if (response.statusCode == 200) {
        _todos[todoIndex] = updatedTodo;
        notifyListeners();
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (error) {
      print('Error updating todo: $error');
    }
  }

  Future<void> deleteTodoById(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      // Assuming the API always returns a success flag in the response body
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        _todos
            .removeWhere((todo) => todo.id == id); // Remove from the local list
        notifyListeners(); // Notify listeners to update the UI
      } else {
        throw Exception(
            'Failed to delete todo'); // This will trigger if the success flag is false
      }
    } catch (error) {
      print('Error deleting todo: $error');
    }
  }

  void clear() {
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }
}
