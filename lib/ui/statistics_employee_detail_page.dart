import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/model/period.dart';

class StatisticsEmployeeDetailPage extends StatefulWidget {
  StatisticsEmployeeDetailPage(
      {required this.employee, required this.employeeJobs, Key? key})
      : super(key: key);

  Employee employee;
  List<Job> employeeJobs;

  @override
  State<StatisticsEmployeeDetailPage> createState() =>
      _StatisticsEmployeeDetailPageState();
}

class _StatisticsEmployeeDetailPageState
    extends State<StatisticsEmployeeDetailPage> {
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
        body: SingleChildScrollView(
            child: Column(
          children: [
            Text(widget.employee.name),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.employeeJobs.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildListHeader(context);
                  return _buildListItem(context, index - 1);
                })
          ],
        )));
  }

  Widget _buildListHeader(context) {
    return ListTile(
      title: Row(
        children: const [
          Expanded(child: Text('入仓时间')),
          Expanded(child: Text('工件')),
          Expanded(child: Text('工序')),
          Expanded(child: Text('单价')),
          Expanded(child: Text('数量')),
          Expanded(child: Text('总价')),
        ],
      ),
    );
  }

  Widget _buildListItem(context, index) {
    var curJob = widget.employeeJobs[index];
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(curJob.ticket.toString())),
          Expanded(child: Text(curJob.artifacts)),
          Expanded(child: Text(curJob.process)),
          Expanded(child: Text(curJob.price.toString())),
          Expanded(child: Text(curJob.count.toString())),
          Expanded(child: Text((curJob.price * curJob.count).toString())),
        ],
      ),
    );
  }
}
