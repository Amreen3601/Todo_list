import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/Providers/Providers.dart';
import 'package:todo_app/View/todo_screen/todo_list.dart';
import 'package:todo_app/constants/routes/routes.dart';

void main() async{
  runApp(const MyApp());
   await Hive.initFlutter();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
          initialRoute: ScreenRoutes.splash,
          onGenerateRoute: ScreenRoutes.generateRoute,
        home: TodoListScreen(),
      ),
    );
  }
}
