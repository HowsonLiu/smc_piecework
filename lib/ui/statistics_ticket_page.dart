import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/ui/common/double_check_dialog.dart';
import 'package:smc_piecework/utils/time_utils.dart';

class StatisticsTicketPageListItem {
  DateTime ticket;
  String artifacts;
  int count;
  List<Job> jobs;
  bool isExpanded;

  StatisticsTicketPageListItem(
      {required this.ticket,
      required this.artifacts,
      required this.jobs,
      required this.count,
      required this.isExpanded});
}

class StatisticsTicketPage extends StatefulWidget {
  const StatisticsTicketPage({required this.period, Key? key})
      : super(key: key);

  final String period;

  @override
  State<StatisticsTicketPage> createState() => _StatisticsTicketPageState();
}

class _StatisticsTicketPageState extends State<StatisticsTicketPage> {
  final Map<DateTime, List<Job>> _jobMap = {};
  final List<StatisticsTicketPageListItem> _items = [];

  @override
  void initState() {
    super.initState();
    _generateJobMapAndItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("工单统计"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          tooltip: "导出",
          onPressed: () => _onSaveButtonClick(context),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
          child: Column(
            children: [
              _buildPeriodTitle(),
              const SizedBox(height: 50),
              _buildPanelList()
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

  Widget _buildPanelList() {
    return Expanded(
        child: SingleChildScrollView(
            child: ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
      children: _buildPanelItem(context),
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _items[panelIndex].isExpanded = !isExpanded;
        });
      },
    )));
  }

  _generateJobMapAndItems() {
    var periodJobs = JobManager.instance.jobs
        .where((element) => element.period == widget.period)
        .toList();
    for (var j in periodJobs) {
      var l = _jobMap[j.ticket] ?? [];
      l.add(j);
      _jobMap[j.ticket] = l;
    }
    for (var k in _jobMap.keys) {
      _items.add(StatisticsTicketPageListItem(
          ticket: k,
          artifacts: _jobMap[k]?.first.artifacts ?? '',
          count: _jobMap[k]?.first.count ?? 0,
          jobs: _jobMap[k] ?? [],
          isExpanded: false));
    }
  }

  List<ExpansionPanel> _buildPanelItem(context) {
    return _items.map<ExpansionPanel>((item) {
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            title: Text('${item.artifacts}(${item.count})'),
            subtitle: Text(getTimeStr(item.ticket)),
          );
        },
        body: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPanelItemBody(item.jobs),
                  const SizedBox(height: 5),
                  Row(children: [
                    const Spacer(),
                    _buildDeleteButton(context, item)
                  ])
                ])),
        isExpanded: item.isExpanded,
      );
    }).toList();
  }

  Widget _buildPanelItemBody(jobs) {
    return DataTable(columns: _buildTableColumn(), rows: _buildTableRow(jobs));
  }

  Widget _buildDeleteButton(context, item) {
    return ElevatedButton(
      child: const Text('删除工单'),
      style: ElevatedButton.styleFrom(primary: Colors.redAccent),
      onPressed: () async {
        bool res =
            await showDoubleCheckDialog(context, '警告⚠️', '工单删除后不可恢复，是否确认');
        if (!res) return;
        await _onDeleteButtonClick(context, item);
      },
    );
  }

  List<DataColumn> _buildTableColumn() {
    return const [
      DataColumn(
          label: Expanded(
              child: Text(
        '员工',
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
    ];
  }

  List<DataRow> _buildTableRow(List<Job> jobs) {
    List<DataRow> dataRows = [];
    for (var job in jobs) {
      var sum = job.count * job.count;
      dataRows.add(DataRow(cells: [
        DataCell(Center(child: Text(job.worker))),
        DataCell(Center(child: Text(job.process))),
        DataCell(Center(child: Text(job.price.toString()))),
        DataCell(Center(child: Text(job.count.toString()))),
        DataCell(Center(child: Text(sum.toString()))),
      ]));
    }
    return dataRows;
  }

  Future<void> _onDeleteButtonClick(context, item) async {
    JobManager.instance.removeJob(item.jobs);
    setState(() {
      _items.remove(item);
    });
  }

  Future<void> _onSaveButtonClick(BuildContext context) async {}
}
