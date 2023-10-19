import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool isCenter;
  const CustomAppBar({required this.title, this.isCenter = false});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: isCenter,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
