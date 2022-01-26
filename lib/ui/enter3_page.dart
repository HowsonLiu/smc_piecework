import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
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
  JobListItem({required this.count, this.employee});
}

class Enter3Page extends StatefulWidget {
  const Enter3Page(
      {Key? key,
      required this.process,
      required this.count,
      required this.tempJobs})
      : super(key: key);

  final ArtifactsProcess process;
  final int count;
  final List<TempJob> tempJobs;

  @override
  State<Enter3Page> createState() => _Enter3PageState();
}

class _Enter3PageState extends State<Enter3Page> {
  final List<JobListItem> _jobItems = [];

  @override
  void initState() {
    super.initState();
    _covertTempJobsToItems();
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
        child: Column(
          children: [
            _buildProcessTitle(),
            const SizedBox(height: 30),
            _buildArtifactsTitle(),
            const SizedBox(height: 30),
            _buildListView()
          ],
        ),
      ),
    );
  }

  Widget _buildProcessTitle() {
    return Text(
      widget.process.processName,
      style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildArtifactsTitle() {
    return Text(
      '${widget.process.artifactsName}(${widget.count}件)',
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildListView() {
    return Expanded(
        child: ListView.builder(
      padding: const EdgeInsets.only(left: 70, right: 70),
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();
        return _buildItems(index);
      },
      itemCount: _jobItems.length + 1,
    ));
  }

  Widget _buildHeader() {
    return ListTile(
      title: Row(children: const [
        Expanded(
          child: Text(
            '员工',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            '数量',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ]),
      trailing: IconButton(
          onPressed: _getLastCount() != 0 ? _addJob : null,
          icon: const Icon(Icons.add)),
    );
  }

  Widget _buildItems(index) {
    JobListItem item = _jobItems[index - 1];
    return ListTile(
      title: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Text(
                item.employee?.name ?? '未设置',
                style: TextStyle(
                    color: item.employee?.name.isNotEmpty ?? false
                        ? Colors.black
                        : Colors.grey),
              ),
              IconButton(
                  onPressed: () => _setEmployee(item),
                  icon: const Icon(Icons.edit)),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Text(item.count.toString()),
              IconButton(
                  onPressed: () => _setCount(item),
                  icon: const Icon(Icons.edit)),
            ],
          )),
        ],
      ),
      trailing: IconButton(
          onPressed: () => _removeJob(item),
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          )),
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
    var e = await showEmployeeInputDialog(context, "作业工人");
    if (e == null) return;
    setState(() {
      item.employee = e;
      _combineSame();
    });
  }

  _setCount(JobListItem item) async {
    var c = await showNumberInputDialog(
        context: context,
        title: "工件数量",
        hint: "数量",
        minValue: 1,
        defalutValue: item.count,
        maxValue: item.count);
    if (c == null) return;
    setState(() {
      item.count = c;
      _combineSame();
    });
  }

  _combineSame() {
    Map<Employee?, JobListItem> m = {};
    _jobItems.removeWhere((i) {
      if (m.containsKey(i.employee)) {
        m[i.employee]?.count += i.count;
        return true;
      } else {
        m.addAll({i.employee: i});
      }
      return false;
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
    widget.tempJobs.clear();
    for (var item in _jobItems) {
      widget.tempJobs.add(TempJob(
        period: PeriodManager.instance.curPeriod?.name ?? '',
        worker: item.employee?.name ?? '',
        artifacts: widget.process.artifactsName,
        process: widget.process.processName,
        price: widget.process.price,
        count: item.count,
      ));
    }
  }

  _covertTempJobsToItems() {
    setState(() {
      _jobItems.clear();
      for (var tempJob in widget.tempJobs) {
        _jobItems.add(JobListItem(
            count: tempJob.count,
            employee: EmployeeManager.instance.employees
                .where((element) => element.name == tempJob.worker)
                .first));
      }
    });
  }

  _finish() {
    if (!_checkItemsValid()) {
      showMessageDialog(context, '错误❌', '请检查工单是否正确');
    } else {
      _convertItemsToTempJobs();
      Navigator.pop(context, widget.tempJobs);
    }
  }
}
