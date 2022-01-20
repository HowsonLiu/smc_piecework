import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/model/period.dart';
import 'package:smc_piecework/ui/statistics_employee_detail_page.dart';

class StatisticsEmployeePage extends StatefulWidget {
  StatisticsEmployeePage({required this.period, Key? key}) : super(key: key);

  String period;

  @override
  State<StatisticsEmployeePage> createState() => _StatisticsEmployeePageState();
}

class _StatisticsEmployeePageState extends State<StatisticsEmployeePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("员工统计"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          tooltip: "导出",
          onPressed: () => _onSaveButtonClick(context),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: EmployeeManager.instance.employees.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, index)),
          ],
        )));
  }

  Widget _buildListItem(context, index) {
    var employee = EmployeeManager.instance.employees[index];
    List<Job> employeeJobs =
        JobManager.instance.getJobs(widget.period, employee);
    num sum = 0;
    for (var j in employeeJobs) {
      sum += j.count * j.price;
    }
    return ListTile(
      title: Text(employee.name),
      subtitle: Text(sum.toString()),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StatisticsEmployeeDetailPage(
            employee: employee,
            employeeJobs: employeeJobs,
          );
        }));
      },
    );
  }

  Future<void> _onSaveButtonClick(BuildContext context) async {}
}
