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
  final Map<ArtifactsProcess, List<TempJob>> _tempJobs = {};

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
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: Column(children: [
              _buildArtifactsTitle(),
              _buildCountTitle(),
              const SizedBox(
                height: 30,
              ),
              _buildListView(),
            ])));
  }

  _onProcessEdited(ArtifactsProcess process) async {
    final res = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Enter3Page(process: process, count: widget.count);
      },
    ));

    if (res != null) {
      setState(() {
        _tempJobs[process] = res;
      });
    }
  }

  _checkValid() {
    bool res = true;
    _tempJobs.forEach((key, value) {
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
      _tempJobs.forEach((key, value) {
        for (var element in value) {
          Job j =
              Job.fromTempJob(tempJob: element, ticket: enterTime, valid: 1);
          JobManager.instance.addJob(j);
        }
      });
      await showMessageDialog(context, '成功', '入仓成功');
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildArtifactsTitle() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          widget.arti.name,
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildCountTitle() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          '${widget.count}件',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildListView() {
    return Expanded(
        child: ListView.builder(
      padding: const EdgeInsets.only(left: 70, right: 70),
      itemBuilder: _buildListItem,
      itemCount: widget.arti.processes.length,
    ));
  }

  Widget _buildListItem(context, index) {
    var process = widget.arti.processes[index];
    var jobList = _tempJobs[process] ?? [];
    var subTitle = List<String>.from(jobList.map((e) {
      var countStr = e.count == widget.count ? '*' : e.count.toString();
      return "${e.worker}($countStr)";
    })).toList().join(', ');
    return ListTile(
      leading: Text(
        process.processIndex.toString(),
        style: const TextStyle(fontSize: 20),
      ),
      title: Text(
        process.processName,
        style: const TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: Icon(
        _tempJobs[process]?.isNotEmpty ?? false
            ? Icons.check
            : Icons.arrow_right,
        color:
            _tempJobs[process]?.isNotEmpty ?? false ? Colors.greenAccent : null,
      ),
      onTap: () => _onProcessEdited(process),
    );
  }
}
