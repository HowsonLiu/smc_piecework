import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/job_manager.dart';

import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/employee_manager.dart';
import 'package:smc_piecework/ui/enter1_page.dart';

import 'package:smc_piecework/ui/settings_page.dart';
import 'package:smc_piecework/ui/statistics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SMC"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHomeCard(
                'assets/image/home_page/enter.jpeg', '入仓', Colors.white, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const Enter1Page();
                },
              ));
            }),
            _buildHomeCard(
                'assets/image/home_page/statistics.jpeg', '统计', Colors.black,
                () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const StatisticsPage();
                },
              ));
            }),
            _buildHomeCard(
                'assets/image/home_page/setting.png', '设置', Colors.black, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const SettingsPage();
                },
              ));
            }),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    EmployeeManager.instance.fetchFromDatabase();
    PeriodManager.instance.fetchFromDatabase();
    ArtifactsManager.instance.fetchFromDatabase();
    PeriodManager.instance.fetchFromLocalStorage();
    JobManager.instance.fetchFromDataBase();
  }

  Widget _buildHomeCard(String imageUrl, String title, Color? titleColor,
      void Function()? callback) {
    return Expanded(
      child: Card(
          margin:
              const EdgeInsets.only(left: 60, right: 60, top: 20, bottom: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          clipBehavior: Clip.antiAlias,
          elevation: 20,
          child: InkWell(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 50,
                            color: titleColor,
                            fontWeight: FontWeight.bold),
                      ),
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                    ),
                  ),
                ],
              ),
              onTap: callback)),
    );
  }
}
