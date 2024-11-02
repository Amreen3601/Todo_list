import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/Models/To_do.dart';

class HiveService {
   HiveService._providerConstructor();
   static final HiveService instance = HiveService._providerConstructor();

Future<Box> get box async {
    return await Hive.openBox('UserSession');
  }

   static Future<void> saveUserInfo(Todo todo) async {
    Box box = await instance.box;
    String userJson = jsonEncode(todo.toJson()); // Convert user to JSON string
    box.put('todoDetails', userJson);
    if (kDebugMode) {
      print("Saved: $userJson");
    }
  }

  static Future getUserToken() async {
    Box box = await instance.box;
    var userprofile = await box.get('userDetails');
    Map<String, dynamic> userMap = jsonDecode(userprofile);
    Todo todo = Todo.fromJson(userMap);
    return todo.token;
  }

  //verification
  static Future<String> checkVerificationStatus() async {
    Box box = await instance.box;
    var userJson = box.get('userDetails');
    if (userJson == null) return '';
    Map<String, dynamic> userMap = jsonDecode(userJson);
    Todo todo = Todo.fromJson(userMap);
    print(todo.token);
    if (todo.token != null) {
      return 'Verified';
    } else {
      return '';
    }
  }
}
