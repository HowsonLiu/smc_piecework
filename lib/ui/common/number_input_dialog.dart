import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NumberInputDialogResultState {
  kOk,
  kEmpty,
  kNotNumber,
  kOverflowMin,
  kOverflowMax
}

extension NumberInputDialogResultStateExtension
    on NumberInputDialogResultState {
  static NumberInputDialogResultState getState(String? text, int min, int max) {
    if (text == null || text.isEmpty) {
      return NumberInputDialogResultState.kEmpty;
    }
    int value = int.parse(text);
    if (value < min) return NumberInputDialogResultState.kOverflowMin;
    if (value > max) return NumberInputDialogResultState.kOverflowMax;
    return NumberInputDialogResultState.kOk;
  }

  static String? getStateTips(NumberInputDialogResultState state) {
    if (state == NumberInputDialogResultState.kEmpty) return "输入不允许为空";
    if (state == NumberInputDialogResultState.kOverflowMin) return "输入值太小";
    if (state == NumberInputDialogResultState.kOverflowMax) return "输入值太大";
  }
}

Future<void> showNumberInputDialog(
    {required BuildContext context,
    required String title,
    required String hint,
    required Function callback,
    int? minValue,
    int? defalutValue,
    int? maxValue}) async {
  final TextEditingController _textFieldController =
      TextEditingController(text: defalutValue?.toString());
  int minVal = minValue ?? 0;
  int maxVal = maxValue ?? 65535;
  NumberInputDialogResultState state =
      NumberInputDialogResultStateExtension.getState(
          _textFieldController.text, minVal, maxVal);
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState2) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: _textFieldController,
                decoration: InputDecoration(hintText: hint),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onChanged: (text) {
                  setState2(() => state =
                      NumberInputDialogResultStateExtension.getState(
                          _textFieldController.text, minVal, maxVal));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                NumberInputDialogResultStateExtension.getStateTips(state) ?? '',
                style: const TextStyle(color: Colors.red),
                maxLines: 1,
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: state == NumberInputDialogResultState.kOk
                  ? () {
                      callback(int.parse(_textFieldController.text));
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
