import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/model/artifacts.dart';
import 'package:smc_piecework/ui/common/number_input_dialog.dart';
import 'package:smc_piecework/ui/enter2_page.dart';

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
        child: Column(
          children: <Widget>[
            Text(_artifacts?.name ?? "未设置"),
            Text(_count != null ? '$_count' : "未设置"),
            TextButton(
              child: const Text('选择工件'),
              onPressed: () => _onArtifactsSelected(context),
            ),
            TextButton(
                onPressed: () => _onCountInput(context),
                child: const Text('选择工件数量')),
            TextButton(
                onPressed: _artifacts != null && _count != null
                    ? () => _onNextStep(context)
                    : null,
                child: const Text('下一步'))
          ],
        ),
      ),
    );
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
}
