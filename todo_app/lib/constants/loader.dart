import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_app/constants/colors.dart';


showLoader({double? size, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.halfTriangleDot(
        color: color ?? AppColors.primaryColor, size: size ?? 30),
  );
}
