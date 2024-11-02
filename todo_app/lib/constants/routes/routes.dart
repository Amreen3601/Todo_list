


import 'package:flutter/material.dart';
import 'package:todo_app/View/todo_screen/splash_screen.dart';
import 'package:todo_app/View/todo_screen/todo_list.dart';
import 'package:todo_app/constants/routes/custom_page_route.dart';

class ScreenRoutes {
  static const String splash = "splash";
  static const String noInternetScreen = "noInternetScreen";
  static const String todo = "todo";
   static const String home = "home";


 static Route<dynamic> generateRoute(RouteSettings settings) {
   switch (settings.name) {
     
      // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  //
      case splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());

      case todo:
        return CustomPageRoute(child:  TodoListScreen());

     
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
   }
 }
}
