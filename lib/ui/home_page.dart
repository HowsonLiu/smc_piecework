// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';

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
          title: Text(PeriodManager.instance.curPeriod?.name ?? "未设置"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: () {},
              child: const Text("入仓"),
            ),
            MaterialButton(
              onPressed: () {
                downloadArtifactsCSVFile();
              },
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
  // ignore: must_call_super
  void initState() {
    EmployeeManager.instance.fetchFromDatabase();
  }

  importArtifactsCSVFile() async {
    PlatformFile? selectedFile;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);
    if (result == null) return;
    selectedFile = result.files.first;
    List<List<dynamic>> data = const CsvToListConverter()
        .convert(const Utf8Decoder().convert(selectedFile.bytes ?? []));
    ArtifactsManager.instance.import(data);
  }

  downloadArtifactsCSVFile() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/HowsonLiu/smc_piecework/main/data/artifacts.csv'));
    if (response.statusCode == 200) {
      List<List<dynamic>> data =
          const CsvToListConverter(eol: '\n', fieldDelimiter: ',')
              .convert(const Utf8Decoder().convert(response.bodyBytes));
      ArtifactsManager.instance.import(data);
    } else {
      throw Exception('Failed to download artifacts csv file');
    }
  }
}
