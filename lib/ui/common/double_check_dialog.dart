import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showDoubleCheckDialog(
    BuildContext context, String title, String content) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("取消")),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("确定"))
          ],
        );
      });
}
