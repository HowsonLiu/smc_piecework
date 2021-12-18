import '../model/employee.dart';

class EmployeeManager {
  EmployeeManager._privateConstructor();
  static final EmployeeManager _instance =
      EmployeeManager._privateConstructor();
  static EmployeeManager get instance => _instance;

  final List<Employee> employees = [];

  import(List<List<dynamic>> data) {
    employees.clear();
    data.asMap().forEach((index, val) {
      employees.add(Employee(index + 1, val[0]));
    });
  }
}
