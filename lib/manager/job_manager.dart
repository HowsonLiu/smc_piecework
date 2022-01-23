import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JobManager {
  JobManager._privateConstructor();
  static final JobManager _instance = JobManager._privateConstructor();
  static JobManager get instance => _instance;

  final JobDataBaseHelper _dbHelper = JobDataBaseHelper();

  final List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  fetchFromDataBase() async {
    var m = await _dbHelper.query();
    if (m != null) {
      _fromMap(m);
    }
  }

  clearDataBase() async {
    await _dbHelper.clear();
  }

  addJob(Job job) {
    _jobs.add(job);
    _dbHelper.insert(job);
  }

  addJobs(List<Job> jobs) {
    _jobs.addAll(jobs);
    for (var job in jobs) {
      _dbHelper.insert(job);
    }
  }

  List<Job> getJobs(String period, Employee e) {
    return jobs
        .where(
            (element) => element.period == period && element.worker == e.name)
        .toList();
  }

  _fromMap(List<Map<String, dynamic>> data) {
    _jobs.clear();
    for (var l in data) {
      _jobs.add(Job(
        ticket:
            DateTime.fromMicrosecondsSinceEpoch(l[JobDataBaseHelper.colTicket]),
        period: l[JobDataBaseHelper.colPeriod],
        worker: l[JobDataBaseHelper.colWorker],
        artifacts: l[JobDataBaseHelper.colArtifacts],
        process: l[JobDataBaseHelper.colProcess],
        price: l[JobDataBaseHelper.colPrice],
        count: l[JobDataBaseHelper.colCount],
        valid: l[JobDataBaseHelper.colValid],
      ));
    }
  }
}

class JobDataBaseHelper {
  static const _databaseName = "smc-jobs.db";
  static const _databaseVersion = 1;
  static const table = "job";
  static const colTicket = "ticket";
  static const colPeriod = "period";
  static const colWorker = "worker";
  static const colArtifacts = "artifacts";
  static const colProcess = "process";
  static const colPrice = "price";
  static const colCount = "count";
  static const colValid = "valid";
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
        $colTicket integer,
        $colPeriod text not null,
        $colWorker text not null,
        $colArtifacts text not null,
        $colProcess text not null,
        $colPrice real not null,
        $colCount integer not null,
        $colValid integer not null
      )
      ''');
    });
  }

  Future<int?> insert(Job e) async {
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
