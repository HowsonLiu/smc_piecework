import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/ui/statistics_employee_detail_page.dart';

class StatisticsEmployeePage extends StatefulWidget {
  const StatisticsEmployeePage({required this.period, Key? key})
      : super(key: key);

  final String period;

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
        body: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w),
          child: Column(
            children: [_buildPeriodTitle(), _buildTable()],
          ),
        ));
  }

  Widget _buildPeriodTitle() {
    return Container(
        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
        child: Text(
          widget.period,
          style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildTable() {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(columns: const [
                DataColumn(
                    label: Expanded(
                        child: Text(
                  '工号',
                  textAlign: TextAlign.center,
                ))),
                DataColumn(
                    label: Expanded(
                        child: Text(
                  '名字',
                  textAlign: TextAlign.center,
                ))),
                DataColumn(
                    label: Expanded(
                        child: Text(
                  '本月薪资',
                  textAlign: TextAlign.center,
                ))),
                DataColumn(
                    label: Expanded(
                        child: Text(
                  '详情',
                  textAlign: TextAlign.center,
                ))),
              ], rows: _buildTableRow()),
            )));
  }

  List<DataRow> _buildTableRow() {
    List<DataRow> dataRows = [];
    for (var e in EmployeeManager.instance.employees) {
      var employeeJobs = JobManager.instance.getJobs(widget.period, e);
      num sum = 0;
      for (var element in employeeJobs) {
        var c = NumUtil.multiply(element.count, element.price);
        sum = NumUtil.add(sum, c);
      }
      dataRows.add(DataRow(cells: [
        DataCell(Center(
            child: Text(
          e.id.toString(),
        ))),
        DataCell(Center(
            child: Text(
          e.name,
        ))),
        DataCell(Center(
            child: Text(
          sum.toString(),
        ))),
        DataCell(Center(
            child: TextButton(
          child: const Text('查看详情'),
          onPressed: sum != 0
              ? () => _jumpToDetailPage(context, e, employeeJobs, sum)
              : null,
        )))
      ]));
    }
    return dataRows;
  }

  _jumpToDetailPage(context, employee, employeeJobs, sum) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StatisticsEmployeeDetailPage(
        sum: sum.toString(),
        employee: employee,
        employeeJobs: employeeJobs,
      );
    }));
  }

  Future<void> _onSaveButtonClick(BuildContext context) async {}
}
