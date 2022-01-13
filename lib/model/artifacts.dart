class ArtifactsProcess {
  String artifactsName;
  int processIndex;
  String processName;
  double price;
  ArtifactsProcess(
      {required this.artifactsName,
      required this.processIndex,
      required this.processName,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      'artifactsName': artifactsName,
      'processIndex': processIndex,
      'processName': processName,
      'price': price
    };
  }
}

class Artifacts {
  String name;
  List<ArtifactsProcess> processes = [];
  Artifacts(this.name);

  addProcess(ArtifactsProcess process) {
    if (!processes.contains(process)) {
      processes.add(process);
    }
  }
}
