import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/period.dart';

class PeriodManager {
  PeriodManager._privateConstructor();
  static final PeriodManager _instance = PeriodManager._privateConstructor();
  static PeriodManager get instance => _instance;

  final PeriodDataBaseHelper _dbHelper = PeriodDataBaseHelper();
  final PeriodLocalStorageHelper _lsHelper = PeriodLocalStorageHelper();

  final List<Period> _periods = [];
  List<Period> get periods => _periods;
  final StreamController<List<Period>> _periodsStreamController =
      StreamController<List<Period>>.broadcast();
  Stream<List<Period>> get periodsStream => _periodsStreamController.stream;

  Period? _curPeriod;
  Period? get curPeriod => _curPeriod;
  set curPeriod(value) => setCurrentPeriod(value);

  fetchFromDatabase() async {
    var m = await _dbHelper.query();
    if (m != null) {
      _fromMap(m);
    }
  }

  fetchFromLocalStorage() async {
    var c = await _lsHelper.get();
    if (c != null) {
      _curPeriod = c;
    }
  }

  addPeriod(String name) {
    var newPeriod = Period(name: name, createTime: DateTime.now());
    _periods.add(newPeriod);
    curPeriod = newPeriod;
    _dbHelper.insert(newPeriod);
    _periodsStreamController.add(_periods);
  }

  removePeriod(String name) {
    _periods.removeWhere((element) => element.name == name);
    curPeriod?.name == name ? curPeriod = null : curPeriod = curPeriod;
    _dbHelper.delete(name);
    _periodsStreamController.add(_periods);
  }

  setCurrentPeriod(Period? p) {
    _curPeriod = p;
    _lsHelper.set(p);
  }

  bool isPeriodExists(String name) {
    return _periods.where((element) => element.name == name).isNotEmpty;
  }

  _fromMap(List<Map<String, dynamic>> data) {
    _periods.clear();
    for (var l in data) {
      _periods.add(Period(
          name: l[PeriodDataBaseHelper.colName],
          createTime: DateTime.fromMillisecondsSinceEpoch(
              l[PeriodDataBaseHelper.colCreateTime])));
    }
  }
}

class PeriodDataBaseHelper {
  static const _databaseName = "smc-period.db";
  static const _databaseVersion = 1;
  static const table = "period";
  static const colName = "name";
  static const colCreateTime = "createTime";
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
        $colName text primary key,
        $colCreateTime integer default 0 not null
      )
      ''');
    });
  }

  Future<int?> insert(Period e) async {
    var db = await database;
    var res = await db?.insert(table, e.toMap());
    return res;
  }

  Future<int?> delete(String name) async {
    var db = await database;
    var res = await db?.delete(table, where: "$colName = ?", whereArgs: [name]);
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

class PeriodLocalStorageHelper {
  static const _periodNameKey = "currentPeriodName";
  static const _periodCreateTimeKey = "currentPeriodCreateName";

  Future<void> set(Period? p) async {
    final prefs = await SharedPreferences.getInstance();
    if (p == null) {
      prefs.remove(_periodNameKey);
      prefs.remove(_periodCreateTimeKey);
    } else {
      prefs.setString(_periodNameKey, p.name);
      prefs.setInt(_periodCreateTimeKey, p.createTime.millisecondsSinceEpoch);
    }
  }

  Future<Period?> get() async {
    Period? res;
    final prefs = await SharedPreferences.getInstance();
    var name = prefs.getString(_periodNameKey);
    var time = prefs.getInt(_periodCreateTimeKey);
    if (name != null && time != null) {
      res = Period(
          name: name, createTime: DateTime.fromMicrosecondsSinceEpoch(time));
    }
    return res;
  }
}
