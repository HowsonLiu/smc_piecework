import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/artifacts.dart';
import 'package:smc_piecework/ui/common/number_input_dialog.dart';
import 'package:smc_piecework/ui/enter2_page.dart';
import 'package:smc_piecework/ui/period_page.dart';

class Enter1Page extends StatefulWidget {
  const Enter1Page({Key? key}) : super(key: key);

  @override
  State<Enter1Page> createState() => _Enter1PageState();
}

class _Enter1PageState extends State<Enter1Page> {
  Artifacts? _artifacts;
  int? _count;

  Artifacts? _selectedArti;

  @override
  void initState() {
    super.initState();
    _artifacts = null;
    _count = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("入仓"),
        ),
        body: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildPeriodTitle(),
              _buildArtifactsTitle(),
              _buildCountTitle(),
              _buildControlBox(),
            ],
          ),
        ));
  }

  Future<void> _onArtifactsSelected(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState2) {
          var _lists = ArtifactsManager.instance.artifactsList;
          return AlertDialog(
            title: const Text('选择工件'),
            content: SizedBox(
                height: 300.0,
                width: 300.0,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var artifacts = _lists[index];
                    return ListTile(
                        leading: Icon(_selectedArti?.name == artifacts.name
                            ? Icons.check
                            : null),
                        title: Text(artifacts.name),
                        onTap: () {
                          setState2(() {
                            _selectedArti = artifacts;
                          });
                        });
                  },
                  itemCount: _lists.length,
                )),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('确定'),
                onPressed: _selectedArti != null
                    ? () {
                        setState(() {
                          _artifacts = _selectedArti;
                        });
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _onCountInput(BuildContext context) async {
    return await showNumberInputDialog(
        context: context,
        title: '工件数量',
        hint: '数量',
        callback: (count) => setState(() => _count = count));
  }

  Future<void> _onNextStep(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _artifacts != null && _count != null
            ? Enter2Page(arti: _artifacts!, count: _count!)
            : Container();
      },
    ));
  }

  Future<void> _onPeriodSelected(context) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const PeriodPage();
      },
    ));
    setState(() {});
  }

  Widget _buildPeriodTitle() {
    return Text(
      PeriodManager.instance.curPeriod?.name ?? '周期设置',
      style: TextStyle(
          fontSize: 50,
          color: (PeriodManager.instance.curPeriod != null
              ? Colors.black
              : Colors.grey),
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildArtifactsTitle() {
    return Text(
      _artifacts?.name ?? '未选择工件',
      style: TextStyle(
          fontSize: 50,
          color: (_artifacts != null ? Colors.black : Colors.grey),
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCountTitle() {
    return Text(
      _count != null ? '$_count件' : '未设置数量',
      style: TextStyle(
          fontSize: 50,
          color: (_count != null ? Colors.black : Colors.grey),
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildControlBox() {
    return Container(
        padding: const EdgeInsets.only(left: 200, right: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PeriodManager.instance.curPeriod == null
                ? ElevatedButton(
                    child: const Text('选择周期'),
                    onPressed: () => _onPeriodSelected(context))
                : Container(),
            ElevatedButton(
              child: const Text('选择工件'),
              onPressed: () => _onArtifactsSelected(context),
            ),
            ElevatedButton(
                onPressed: () => _onCountInput(context),
                child: const Text('选择工件数量')),
            ElevatedButton(
                onPressed: _artifacts != null && _count != null
                    ? () => _onNextStep(context)
                    : null,
                child: const Text('下一步'))
          ],
        ));
  }
}
