import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_app/Controllers/todo_controller.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
  ];
}
