import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/ui/statistics_employee_page.dart';
import 'package:smc_piecework/ui/statistics_ticket_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("统计"),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPeriodTitle(),
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
                                    PeriodManager.instance.curPeriod?.name ??
                                        '');
                          }));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.list),
                        title: const Text("按照工单分类"),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return StatisticsTicketPage(
                                period:
                                    PeriodManager.instance.curPeriod?.name ??
                                        '');
                          }));
                        },
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  _buildPeriodTitle() {
    return Text(
      PeriodManager.instance.curPeriod?.name ?? '未设置',
      style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
    );
  }
}
