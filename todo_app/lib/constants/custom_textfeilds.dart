import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/custom_textstyles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final TextStyle? labelStyle;
  final bool isBorder;

  CustomTextField({
    required this.controller,
     this.hintText,
     this.labelText,
     this.labelStyle,
    this.isBorder = false, 
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: labelStyle,
        border: isBorder ? OutlineInputBorder() : null,
      ),
    );
  }
}
