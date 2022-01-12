import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/period_manager.dart';
import 'package:smc_piecework/model/period.dart';

class PeriodPage extends StatefulWidget {
  const PeriodPage({Key? key}) : super(key: key);

  @override
  State<PeriodPage> createState() => _PeriodPageState();
}

class _PeriodPageState extends State<PeriodPage> {
  final TextEditingController _textFieldController = TextEditingController();
  bool _okBtnEnabled = true;

  @override
  void initState() {
    super.initState();
    _okBtnEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("月份设置"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: "新增",
          onPressed: () => _onAddButtonClick(context),
        ),
        body: StreamBuilder<List<Period>>(
          stream: PeriodManager.instance.periodsStream,
          builder: (context, snapshot) {
            List<Period>? _dataLists = snapshot.data;
            List<Period> _lists = _dataLists ?? PeriodManager.instance.periods;
            return ListView.builder(
              itemBuilder: (context, index) =>
                  _buildListItem(context, _lists[index]),
              itemCount: _lists.length,
            );
          },
        ));
  }

  Widget _buildListItem(context, period) {
    var cur = PeriodManager.instance.curPeriod;
    return ListTile(
        leading: Icon(cur?.name == period.name ? Icons.check : null),
        title: Text(period.name),
        onTap: () {
          setState(() {
            PeriodManager.instance.curPeriod = period;
          });
        },
        onLongPress: () => _onDelete(context, period));
  }

  Future<void> _onAddButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('月份名称'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "月份"),
              onChanged: (text) {
                setState(() {
                  _okBtnEnabled = !PeriodManager.instance.isPeriodExists(text);
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              _buildDialogOkbutton(),
            ],
          );
        });
      },
    );
  }

  Widget _buildDialogOkbutton() {
    return TextButton(
      child: const Text('确定'),
      onPressed: _okBtnEnabled
          ? () {
              PeriodManager.instance.addPeriod(_textFieldController.text);
              Navigator.pop(context);
            }
          : null,
    );
  }

  Future<void> _onDelete(BuildContext context, Period p) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('警告'),
            content: Text("是否删除月份 '${p.name}'"),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  PeriodManager.instance.removePeriod(p.name);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
