import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/model/period.dart';
import 'package:smc_piecework/utils/time_utils.dart';

class StatisticsEmployeeDetailPage extends StatefulWidget {
  const StatisticsEmployeeDetailPage(
      {required this.employee,
      required this.employeeJobs,
      required this.period,
      Key? key})
      : super(key: key);

  final String period;
  final Employee employee;
  final List<Job> employeeJobs;

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
        body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
              _buildEmployeeTitle(),
              const SizedBox(height: 30),
              _buildPeriodTitle(),
              const SizedBox(height: 50),
              _buildTable()
            ],
          ),
        ));
  }

  Widget _buildPeriodTitle() {
    return Text(
      widget.period,
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmployeeTitle() {
    return Text(
      widget.employee.name,
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTable() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(columns: const [
          DataColumn(
              label: Expanded(
                  child: Text(
            '入仓时间',
            textAlign: TextAlign.center,
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            '工件',
            textAlign: TextAlign.center,
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            '工序',
            textAlign: TextAlign.center,
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            '单价',
            textAlign: TextAlign.center,
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            '数量',
            textAlign: TextAlign.center,
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            '总价',
            textAlign: TextAlign.center,
          ))),
        ], rows: _buildTableRow()),
      ],
    )));
  }

  List<DataRow> _buildTableRow() {
    List<DataRow> dataRows = [];
    for (var job in widget.employeeJobs) {
      dataRows.add(DataRow(cells: [
        DataCell(Center(child: Text(getTimeStr(job.ticket)))),
        DataCell(Center(child: Text(job.artifacts))),
        DataCell(Center(child: Text(job.process))),
        DataCell(Center(child: Text(job.price.toString()))),
        DataCell(Center(child: Text(job.count.toString()))),
        DataCell(Center(child: Text((job.count * job.price).toString()))),
      ]));
    }
    return dataRows;
  }
}
