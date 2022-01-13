import 'dart:convert';
import 'dart:async';

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

  final Map<String, Artifacts> artifactses = {};

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

  overrideDatabase() async {
    await _dbHelper.clear();
    artifactses.forEach((key, value) async {
      for(var p in value.processes) {
        await _dbHelper.insert(p);
      }
    });
  }

  _fromList(List<List<dynamic>> data) {
    artifactses.clear();
    for(var val in data) {
      String artifactsName = val[0];
      var process = ArtifactsProcess(
          artifactsName: artifactsName,
          processIndex: val[1],
          processName: val[2],
          price:  val[3].toDouble());
      Artifacts artifacts = artifactses[artifactsName] ?? Artifacts(artifactsName);
      artifacts.addProcess(process);
      artifactses[artifactsName] = artifacts;
    }
  }

  _fromMap(List<Map<String, dynamic>> data) {
    artifactses.clear();
    for (var val in data) {
      String artifactsName = val[ArtifactsDataBaseHelper.colArtifactsName];
      var process = ArtifactsProcess(
          artifactsName: artifactsName,
          processIndex: val[ArtifactsDataBaseHelper.colProcessIndex],
          processName: val[ArtifactsDataBaseHelper.colProcessName],
          price: val[ArtifactsDataBaseHelper.colPrice]);
      Artifacts artifacts = artifactses[artifactsName] ?? Artifacts(artifactsName);
      artifacts.addProcess(process);
      artifactses[artifactsName] = artifacts;
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
