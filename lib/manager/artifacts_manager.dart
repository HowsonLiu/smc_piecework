import 'dart:convert';
import 'dart:async';

import 'package:file_picker/file_picker.dart';

import '../model/artifacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

class ArtifactsManager {
  ArtifactsManager._privateConstructor();
  static final ArtifactsManager _instance =
      ArtifactsManager._privateConstructor();
  static ArtifactsManager get instance => _instance;

  final ArtifactsDataBaseHelper _dbHelper = ArtifactsDataBaseHelper();
  final ArtifactsNetHelper _netHelper = ArtifactsNetHelper();
  final ArtifactsFileHelper _fileHelper = ArtifactsFileHelper();

  final Map<String, Artifacts> _artifactsesMap = {};
  List<Artifacts> get artifactsList =>
      _artifactsesMap.entries.map((e) => e.value).toList();

  fetchFromDatabase() async {
    var m = await _dbHelper.query();
    if (m != null) {
      _fromMap(m);
    }
  }

  fetchFromNet() async {
    var l = await _netHelper.query();
    if (l != null) {
      _fromList(l);
    }
  }

  fetchFromFile() async {
    var l = await _fileHelper.fetch();
    if (l != null) {
      _fromList(l);
    }
  }

  overrideDatabase() async {
    await _dbHelper.clear();
    _artifactsesMap.forEach((key, value) async {
      for (var p in value.processes) {
        await _dbHelper.insert(p);
      }
    });
  }

  _fromList(List<List<dynamic>> data) {
    _artifactsesMap.clear();
    for (var val in data) {
      String artifactsName = val[0];
      var process = ArtifactsProcess(
          artifactsName: artifactsName,
          processIndex: val[1],
          processName: val[2],
          price: val[3].toDouble());
      Artifacts artifacts =
          _artifactsesMap[artifactsName] ?? Artifacts(artifactsName);
      artifacts.addProcess(process);
      _artifactsesMap[artifactsName] = artifacts;
    }
  }

  _fromMap(List<Map<String, dynamic>> data) {
    _artifactsesMap.clear();
    for (var val in data) {
      String artifactsName = val[ArtifactsDataBaseHelper.colArtifactsName];
      var process = ArtifactsProcess(
          artifactsName: artifactsName,
          processIndex: val[ArtifactsDataBaseHelper.colProcessIndex],
          processName: val[ArtifactsDataBaseHelper.colProcessName],
          price: val[ArtifactsDataBaseHelper.colPrice]);
      Artifacts artifacts =
          _artifactsesMap[artifactsName] ?? Artifacts(artifactsName);
      artifacts.addProcess(process);
      _artifactsesMap[artifactsName] = artifacts;
    }
  }
}

class ArtifactsDataBaseHelper {
  static const _databaseName = "smc-artifacts.db";
  static const _databaseVersion = 1;
  static const table = "artifacts";
  static const colArtifactsName = 'artifactsName';
  static const colProcessIndex = 'processIndex';
  static const colProcessName = 'processName';
  static const colPrice = 'price';
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      await db.execute('''
      create table $table (
        $colArtifactsName text not null,
        $colProcessIndex integer not null,
        $colProcessName text not null,
        $colPrice real not null
      )
      ''');
    });
  }

  Future<int?> insert(ArtifactsProcess e) async {
    var db = await database;
    var res = await db?.insert(table, e.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>?> query() async {
    var db = await database;
    var res = await db?.query(table);
    return res;
  }

  Future<void> clear() async {
    var db = await database;
    await db?.rawQuery("delete from $table");
  }
}

class ArtifactsNetHelper {
  static const _url =
      "https://raw.githubusercontent.com/HowsonLiu/smc_piecework/main/data/artifacts.csv";

  Future<List<List<dynamic>>?> query() async {
    final response = await http.get(Uri.parse(_url));
    List<List<dynamic>>? data;
    if (response.statusCode == 200) {
      data = const CsvToListConverter(eol: '\n', fieldDelimiter: ',')
          .convert(const Utf8Decoder().convert(response.bodyBytes));
    }
    return data;
  }
}

class ArtifactsFileHelper {
  Future<List<List<dynamic>>?> fetch() async {
    List<List<dynamic>>? data;
    PlatformFile? selectedFile;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);
    if (result != null) {
      selectedFile = result.files.first;
      data = const CsvToListConverter()
          .convert(const Utf8Decoder().convert(selectedFile.bytes ?? []));
    }
    return data;
  }
}
