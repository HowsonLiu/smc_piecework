import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/model/employee.dart';

Future<Employee?> showEmployeeInputDialog(
    BuildContext context, String title) async {
  Employee? _selectEmployee;
  List<Employee> _showEmployeeList = EmployeeManager.instance.employees;
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(title),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: '工号或姓名'),
                  onChanged: (value) {
                    setState(() {
                      _showEmployeeList =
                          EmployeeManager.instance.employees.where((element) {
                        return element.id.toString().contains(value) ||
                            element.name.toString().contains(value);
                      }).toList();
                    });
                  },
                ),
                SizedBox(height: 10.h),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Scrollbar(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              var employee = _showEmployeeList[index];
                              return ListTile(
                                  leading: Icon(
                                      _selectEmployee?.id == employee.id
                                          ? Icons.check
                                          : null),
                                  title: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(employee.id.toString())),
                                      Expanded(
                                          flex: 1, child: Text(employee.name))
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() => _selectEmployee = employee);
                                  });
                            },
                            itemCount: _showEmployeeList.length)))
              ]),
          actions: <Widget>[
            TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context)),
            TextButton(
              child: const Text('确定'),
              onPressed: _selectEmployee != null
                  ? () => Navigator.pop(context, _selectEmployee)
                  : null,
            ),
          ],
        );
      });
    },
  );
}
