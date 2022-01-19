import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/ui/period_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("统计"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Text(PeriodManager.instance.curPeriod?.name ?? '未设置')),
            Card(
              margin: const EdgeInsets.all(30.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text("按照员工分类"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.list),
                    title: Text("按照工单分类"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
