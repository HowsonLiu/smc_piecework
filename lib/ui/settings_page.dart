import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/job_manager.dart';
import 'package:smc_piecework/ui/common/double_check_dialog.dart';
import 'package:smc_piecework/ui/common/message_dialog.dart';
import 'package:smc_piecework/ui/period_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("设置"),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.purple,
              child: ListTile(
                title: Builder(builder: (context) {
                  return const Text("月份");
                }),
                leading: const Icon(Icons.edit),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const PeriodPage();
                    },
                  ));
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.download,
                        color: Colors.purple,
                      ),
                      title: const Text("从网络更新数据"),
                      onTap: () {
                        _updateFromNet();
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.download,
                        color: Colors.purple,
                      ),
                      title: const Text("从本地更新数据"),
                      onTap: () {
                        _updateFromFile();
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.upload,
                        color: Colors.purple,
                      ),
                      title: const Text("备份数据"),
                      onTap: () {},
                    ),
                  ],
                )),
            _buildDangerZoneCard(context)
          ],
        )));
  }

  _buildDangerZoneCard(context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.redAccent,
      child: ListTile(
        title: Builder(builder: (context) {
          return const Text("清理数据");
        }),
        leading: const Icon(Icons.dangerous),
        onTap: () => _deleteLocalData(context),
      ),
    );
  }

  _updateFromNet() async {
    await EmployeeManager.instance.fetchFromNet();
    await EmployeeManager.instance.overrideDatabase();
    await ArtifactsManager.instance.fetchFromNet();
    await ArtifactsManager.instance.overrideDatabase();
  }

  _updateFromFile() async {
    await EmployeeManager.instance.fetchFromFile();
    await EmployeeManager.instance.overrideDatabase();
    await ArtifactsManager.instance.fetchFromFile();
    await ArtifactsManager.instance.overrideDatabase();
  }

  _deleteLocalData(context) async {
    bool res =
        await showDoubleCheckDialog(context, '危险⚠️', '是否确定清除本地数据，数据清除后不可恢复');
    if (res) {
      await JobManager.instance.clearDataBase();
      await showMessageDialog(context, '成功', '数据清除成功');
    }
  }
}
