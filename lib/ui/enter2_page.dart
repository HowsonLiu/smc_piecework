import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smc_piecework/model/artifacts.dart';
import 'package:smc_piecework/model/job.dart';
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
      ),
      body: Container(
        child: Column(
          children: [
            Text('${widget.arti.name}——${widget.count}件'),
            ListView.builder(
              itemBuilder: (context, index) {
                var processes = widget.arti.processes;
                return ListTile(
                  leading: Text(processes[index].processIndex.toString()),
                  title: Text(processes[index].processName),
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

    setState(() {
      _jobs[process] = res;
    });
  }
}
