import 'package:flutter/material.dart';
import 'package:smc_piecework/manager/artifacts_manager.dart';
import 'package:smc_piecework/model/artifacts.dart';

Future<Artifacts?> showArtifactsInputDialog(
    BuildContext context, String title) async {
  Artifacts? _selectedArtifacts;
  List<Artifacts> _showArtifactsList = ArtifactsManager.instance.artifactsList;
  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(title),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: '工件名称'),
                  onChanged: (value) {
                    setState(() {
                      _showArtifactsList = ArtifactsManager
                          .instance.artifactsList
                          .where((element) {
                        return element.name
                            .toLowerCase()
                            .contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Scrollbar(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              var artifacts = _showArtifactsList[index];
                              return ListTile(
                                  leading: Icon(
                                      _selectedArtifacts?.name == artifacts.name
                                          ? Icons.check
                                          : null),
                                  title: Text(artifacts.name),
                                  onTap: () {
                                    setState(
                                        () => _selectedArtifacts = artifacts);
                                  });
                            },
                            itemCount: _showArtifactsList.length)))
              ]),
          actions: <Widget>[
            TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context)),
            TextButton(
              child: const Text('确定'),
              onPressed: _selectedArtifacts != null
                  ? () => Navigator.pop(context, _selectedArtifacts)
                  : null,
            ),
          ],
        );
      });
    },
  );
}
