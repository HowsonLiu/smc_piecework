import 'dart:async';
import 'package:flutter/material.dart';

Future<void> showMessageDialog(
    BuildContext context, String title, String content) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("确定"))
          ],
        );
      });
}
