// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../manager/artifacts_manager.dart';
import '../manager/employee_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          onPressed: () {
            importEmployeeCSVFile();
          },
          child: const Text("开始"),
        ),
        MaterialButton(
          onPressed: () {
            importArtifactsCSVFile();
          },
          child: const Text("设置"),
        ),
      ],
    ));
  }

  importEmployeeCSVFile() async {
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
    EmployeeManager.instance.import(data);
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
}
