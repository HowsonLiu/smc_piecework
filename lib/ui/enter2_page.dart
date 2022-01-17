import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/model/artifacts.dart';
import 'package:smc_piecework/model/job.dart';
import 'package:smc_piecework/ui/common/message_dialog.dart';
import 'package:smc_piecework/ui/enter3_page.dart';

class Enter2Page extends StatefulWidget {
  const Enter2Page({Key? key, required this.arti, required this.count})
      : super(key: key);

  final Artifacts arti;
  final int count;

  @override
  State<Enter2Page> createState() => _Enter2PageState();
}

class _Enter2PageState extends State<Enter2Page> {
  final Map<ArtifactsProcess, List<Job>> _jobs = {};

  @override
  void initState() {
    super.initState();
    _jobs.clear();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${widget.arti.name}——${widget.count}件'),
            ListView.builder(
              itemBuilder: (context, index) {
                var processes = widget.arti.processes;
                var jobList = _jobs[processes[index]];
                return ListTile(
                  leading: Text(processes[index].processIndex.toString()),
                  title: Text(processes[index].processName),
                  subtitle: Text(_getSubTitleText(jobList)),
                  trailing: Icon(_jobs[processes[index]]?.isNotEmpty ?? false
                      ? Icons.check
                      : null),
                  onTap: () => _onProcessEdited(processes[index]),
                );
              },
              itemCount: widget.arti.processes.length,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  _onProcessEdited(ArtifactsProcess process) async {
    final res = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Enter3Page(process: process, count: widget.count);
      },
    ));

    if (res != null) {
      setState(() {
        _jobs[process] = res;
      });
    }
  }

  _getSubTitleText(List<Job>? jobs) {
    if (jobs?.isEmpty ?? true) return '未设置';
    return jobs?.join(', ');
  }

  _checkValid() {
    bool res = true;
    _jobs.forEach((key, value) {
      if (value.isEmpty) res = false;
    });
    return res;
  }

  _finish() async {
    if (!_checkValid()) {
      await showMessageDialog(context, '错误❌', '请检查是否所有工序都已完成');
    } else {
      // todo double check
      DateTime enterTime = DateTime.now();
      _jobs.forEach((key, value) {
        for (var element in value) {
          element.ticket = enterTime;
        }
        JobManager.instance.addJobs(value);
      });
      await showMessageDialog(context, '成功', '入仓成功');
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
