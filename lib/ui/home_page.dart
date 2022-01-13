// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/model/period.dart';

import 'package:smc_piecework/ui/settings_page.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SMC"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: () {},
              child: const Text("入仓"),
            ),
            MaterialButton(
              onPressed: () {},
              child: const Text("统计"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SettingsPage();
                  },
                ));
              },
              child: const Text("设置"),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    EmployeeManager.instance.fetchFromDatabase();
    PeriodManager.instance.fetchFromDatabase();
    ArtifactsManager.instance.fetchFromDatabase();
    PeriodManager.instance.fetchFromLocalStorage();
  }
}
