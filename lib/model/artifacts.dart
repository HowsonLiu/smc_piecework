class ArtifactsProcess {
  String name;
  int price;
  ArtifactsProcess(this.name, this.price);
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
