import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double elevation;
  final Color backgroundColor;
  final TextStyle? titleTextStyle;
  final Color iconColor;
  final List<Widget>? actions;
  final bool centerTitle;
  final Function()? onLeadingPressed;
  final PreferredSizeWidget? bottom; // Added for TabBar

  CustomAppBar({
    Key? key,
    required this.title,
    this.elevation = 4.0,
    this.backgroundColor = Colors.blue,
    this.titleTextStyle,
    this.iconColor = Colors.white,
    this.actions,
    this.centerTitle = true,
    this.onLeadingPressed,
    this.bottom, // Accepting TabBar as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: titleTextStyle ?? TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: iconColor),
        onPressed: onLeadingPressed ?? () {},
      ),
      actions: actions,
      bottom: bottom, // Adding TabBar here
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0)); // Adjusting preferred size
}
