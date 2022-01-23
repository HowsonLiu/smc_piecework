import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/artifacts.dart';
import 'package:smc_piecework/model/employee.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/ui/common/employee_input_dialog.dart';
import 'package:smc_piecework/ui/common/message_dialog.dart';
import 'package:smc_piecework/ui/common/number_input_dialog.dart';

class JobListItem {
  Employee? employee;
  int count;
  JobListItem({required this.count});
}

class Enter3Page extends StatefulWidget {
  const Enter3Page({Key? key, required this.process, required this.count})
      : super(key: key);

  final ArtifactsProcess process;
  final int count;

  @override
  State<Enter3Page> createState() => _Enter3PageState();
}

class _Enter3PageState extends State<Enter3Page> {
  final List<TempJob> _tempJobs = [];
  final List<JobListItem> _jobItems = [];

  @override
  void initState() {
    super.initState();
    _tempJobs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("入仓"),
        actions: [
          IconButton(onPressed: _finish, icon: const Icon(Icons.check))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.process.artifactsName),
            Text(widget.process.processName),
            Text('${widget.count}件'),
            ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader();
                return _buildItems(_jobItems[index - 1]);
              },
              itemCount: _jobItems.length + 1,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      title: Row(
        children: [
          const Expanded(
            child: Text('员工'),
          ),
          const Expanded(
            child: Text('数量'),
          ),
          Expanded(
              child: IconButton(
                  onPressed: _getLastCount() != 0 ? _addJob : null,
                  icon: const Icon(Icons.add)))
        ],
      ),
    );
  }

  Widget _buildItems(JobListItem item) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(item.employee?.name ?? '')),
          IconButton(
              onPressed: () => _setEmployee(item),
              icon: const Icon(Icons.edit)),
          Expanded(child: Text(item.count.toString())),
          IconButton(
              onPressed: () => _setCount(item), icon: const Icon(Icons.edit)),
        ],
      ),
      trailing: IconButton(
          onPressed: () => _removeJob(item), icon: const Icon(Icons.delete)),
    );
  }

  _getLastCount() {
    int lastCount = widget.count;
    for (var element in _jobItems) {
      lastCount -= element.count;
    }
    return lastCount;
  }

  _addJob() {
    setState(() {
      _jobItems.add(JobListItem(count: _getLastCount()));
    });
  }

  _setEmployee(JobListItem item) async {
    return await showEmployeeInputDialog(context, "作业工人", (employee) {
      setState(() {
        item.employee = employee;
      });
    });
  }

  _setCount(JobListItem item) async {
    return await showNumberInputDialog(
        context: context,
        title: "工件数量",
        hint: "数量",
        minValue: 1,
        defalutValue: item.count,
        maxValue: item.count,
        callback: (count) {
          setState(() {
            item.count = count;
          });
        });
  }

  _removeJob(JobListItem item) {
    setState(() {
      _jobItems.remove(item);
    });
  }

  _checkItemsValid() {
    var totalCount = 0;
    for (var item in _jobItems) {
      if (item.employee == null) {
        return false;
      }
      totalCount += item.count;
    }
    return totalCount == widget.count;
  }

  _convertItemsToTempJobs() {
    _tempJobs.clear();
    for (var item in _jobItems) {
      _tempJobs.add(TempJob(
        period: PeriodManager.instance.curPeriod?.name ?? '',
        worker: item.employee?.name ?? '',
        artifacts: widget.process.artifactsName,
        process: widget.process.processName,
        price: widget.process.price,
        count: item.count,
      ));
    }
  }

  _finish() {
    if (!_checkItemsValid()) {
      showMessageDialog(context, '错误❌', '请检查工单是否正确');
    } else {
      _convertItemsToTempJobs();
      Navigator.pop(context, _tempJobs);
    }
  }
}
