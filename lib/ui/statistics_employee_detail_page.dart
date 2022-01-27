import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/utils/time_utils.dart';

class StatisticsEmployeeDetailPage extends StatefulWidget {
  const StatisticsEmployeeDetailPage(
      {required this.employee,
      required this.employeeJobs,
      required this.sum,
      Key? key})
      : super(key: key);

  final String sum;
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
          margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 30.h),
          child: Column(
            children: [
              _buildEmployeeTitle(),
              SizedBox(height: 30.h),
              _buildSumTitle(),
              SizedBox(height: 50.h),
              _buildTable()
            ],
          ),
        ));
  }

  Widget _buildSumTitle() {
    return Text(
      '${widget.sum}元',
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
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(columns: const [
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
            )));
  }

  List<DataRow> _buildTableRow() {
    List<DataRow> dataRows = [];
    for (var job in widget.employeeJobs) {
      var sum = NumUtil.multiply(job.count, job.price);
      dataRows.add(DataRow(cells: [
        DataCell(Center(child: Text(getTimeStr(job.ticket)))),
        DataCell(Center(child: Text(job.artifacts))),
        DataCell(Center(child: Text(job.process))),
        DataCell(Center(child: Text(job.price.toString()))),
        DataCell(Center(child: Text(job.count.toString()))),
        DataCell(Center(child: Text(sum.toString()))),
      ]));
    }
    return dataRows;
  }
}
