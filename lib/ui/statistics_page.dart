import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/ui/period_page.dart';
import 'package:smc_piecework/ui/statistics_employee_page.dart';

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
                children: [
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text("按照员工分类"),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StatisticsEmployeePage(
                            period:
                                PeriodManager.instance.curPeriod?.name ?? '');
                      }));
                    },
                  ),
                  const ListTile(
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
