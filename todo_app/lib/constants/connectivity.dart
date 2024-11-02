import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/routes/routes.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> checkConnectivity(BuildContext context) async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, ScreenRoutes.noInternetScreen);
      return false;
    }
    return true;
  }
}
