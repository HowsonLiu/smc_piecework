import 'dart:convert';

import '../model/employee.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

class EmployeeManager {
  EmployeeManager._privateConstructor();
  static final EmployeeManager _instance =
      EmployeeManager._privateConstructor();
  static EmployeeManager get instance => _instance;

  final List<Employee> employees = [];

  downloadFromNet() {
    try{
    _downloadEmployeeCSVFile();
    } catch (e) {
      return false;
    }
    return true;
  }

  _downloadEmployeeCSVFile() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/HowsonLiu/smc_piecework/main/data/employee.csv'));
    if (response.statusCode == 200) {
      List<List<dynamic>> data =
          const CsvToListConverter(eol: '\n', fieldDelimiter: ',')
              .convert(const Utf8Decoder().convert(response.bodyBytes));
      import(data);
    } else {
      throw Exception('Failed to download employee csv file');
    }
  }

  import(List<List<dynamic>> data) {
    employees.clear();
    data.asMap().forEach((index, val) {
      employees.add(Employee(index + 1, val[0]));
    });
  }
}
