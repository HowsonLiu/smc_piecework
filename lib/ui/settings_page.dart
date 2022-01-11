import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/employee_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("设置"),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.purple,
              child: ListTile(
                title: Builder(builder: (context) {
                  return const Text("月份");
                }),
                leading: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.download,
                        color: Colors.purple,
                      ),
                      title: const Text("更新数据"),
                      onTap: () {
                        _updateData();
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.upload,
                        color: Colors.purple,
                      ),
                      title: const Text("备份数据"),
                      onTap: () {},
                    ),
                  ],
                ))
          ],
        )));
  }

  _updateData() async {
    await EmployeeManager.instance.fetchFromNet();
    await EmployeeManager.instance.overrideDatabase();
  }
}
