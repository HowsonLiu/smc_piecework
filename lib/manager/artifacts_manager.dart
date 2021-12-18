import '../model/artifacts.dart';

class ArtifactsManager {
  ArtifactsManager._privateConstructor();
  static final ArtifactsManager _instance =
      ArtifactsManager._privateConstructor();
  static ArtifactsManager get instance => _instance;

  final Map<String, Artifacts> artifactses = {};

  import(List<List<dynamic>> data) {
    artifactses.clear();
    for (var val in data) {
      if (!artifactses.containsKey(val[0])) {
        artifactses[val[0]] = Artifacts(val[0]);
      }
      artifactses[val[0]]?.addProcess(ArtifactsProcess(val[1], val[2]));
    }
  }
}
