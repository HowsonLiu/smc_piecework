import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/model/employee.dart';

Future<void> showEmployeeInputDialog(
    BuildContext context, String title, Function callback) async {
  Employee? _selectEmployee;
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState2) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
              height: 300.0,
              width: 300.0,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    var employee = EmployeeManager.instance.employees[index];
                    return ListTile(
                        leading: Icon(_selectEmployee?.id == employee.id
                            ? Icons.check
                            : null),
                        title: Row(
                          children: [
                            Expanded(child: Text(employee.id.toString())),
                            Expanded(child: Text(employee.name))
                          ],
                        ),
                        onTap: () {
                          setState2(() => _selectEmployee = employee);
                        });
                  },
                  itemCount: EmployeeManager.instance.employees.length)),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: _selectEmployee != null
                  ? () {
                      callback(_selectEmployee);
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ],
        );
      });
    },
  );
}
