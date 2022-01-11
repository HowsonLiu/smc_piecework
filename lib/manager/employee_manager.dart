import 'dart:convert';
import 'dart:async';

import '../model/employee.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeManager {
  EmployeeManager._privateConstructor();
  static final EmployeeManager _instance =
      EmployeeManager._privateConstructor();
  static EmployeeManager get instance => _instance;

  final EmployeeDataBaseHelper _dbHelper = EmployeeDataBaseHelper();
  final EmployeeNetHelper _netHelper = EmployeeNetHelper();
  List<Employee> employees = [];

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
    for (var e in employees) {
      await _dbHelper.insert(e);
    }
  }

  _fromList(List<List<dynamic>> data) {
    employees.clear();
    data.asMap().forEach((index, val) {
      employees.add(Employee.fromFlat(index + 1, val[0]));
    });
  }

  _fromMap(List<Map<String, dynamic>> data) {
    employees.clear();
    for (var l in data) {
      employees.add(Employee.fromMap(id: l['id'], name: l['name']));
    }
  }
}

class EmployeeDataBaseHelper {
  static const _databaseName = "smc.db";
  static const _databaseVersion = 1;
  static const table = "employee";
  static const colId = 'id';
  static const colName = 'name';
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
        $colId integer primary key,
        $colName text not null
      )
      ''');
    });
  }

  Future<int?> insert(Employee e) async {
    var db = await database;
    var res = await db?.insert(table, e.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>?> query() async {
    var db = await database;
    var res = await db?.query(table, orderBy: '$colId desc');
    return res;
  }

  Future<void> clear() async {
    var db = await database;
    await db?.rawQuery("delete from $table");
  }
}

class EmployeeNetHelper {
  static const _url =
      "https://raw.githubusercontent.com/HowsonLiu/smc_piecework/main/data/employee.csv";

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

class EmployeeFileHelper {
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
