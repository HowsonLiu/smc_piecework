import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/utils/time_utils.dart';

class StatisticsTicketPageListItem {
  DateTime ticket;
  String artifacts;
  List<Job> jobs;
  bool isExpanded;

  StatisticsTicketPageListItem(
      {required this.ticket,
      required this.artifacts,
      required this.jobs,
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
        body: SingleChildScrollView(
            child: ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 500),
          children: _buildPanelItem(context),
          expansionCallback: (panelIndex, isExpanded) {
            _items[panelIndex].isExpanded = !isExpanded;
            setState(() {});
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
      _jobMap[j.ticket!] = l;
    }
    for (var k in _jobMap.keys) {
      _items.add(StatisticsTicketPageListItem(
          ticket: k,
          artifacts: _jobMap[k]?.first.artifacts ?? '',
          jobs: _jobMap[k] ?? [],
          isExpanded: false));
    }
  }

  List<ExpansionPanel> _buildPanelItem(context) {
    return _items.map<ExpansionPanel>((item) {
      return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            title: Text(getTimeStr(item.ticket) + ', ' + item.artifacts),
          );
        },
        body: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) return _buildListHeader(context);
            return _buildListItem(context, item.jobs[index - 1]);
          },
          itemCount: item.jobs.length + 1,
          shrinkWrap: true,
        ),
        isExpanded: item.isExpanded,
      );
    }).toList();
  }

  Widget _buildListHeader(context) {
    return ListTile(
      title: Row(
        children: const [
          Expanded(child: Text('员工')),
          Expanded(child: Text('工序')),
          Expanded(child: Text('单价')),
          Expanded(child: Text('数量')),
          Expanded(child: Text('总价')),
        ],
      ),
    );
  }

  Widget _buildListItem(context, Job job) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(job.worker)),
          Expanded(child: Text(job.process)),
          Expanded(child: Text(job.price.toString())),
          Expanded(child: Text(job.count.toString())),
          Expanded(child: Text((job.price * job.count).toString())),
        ],
      ),
    );
  }

  Future<void> _onSaveButtonClick(BuildContext context) async {}
}
