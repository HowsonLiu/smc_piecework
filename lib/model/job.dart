class Job {
  String period = "";
  String worker = "";
  String artifacts = "";
  String process = "";
  double price = 0;
  int count = 0;

  Job(
      {required this.period,
      required this.worker,
      required this.artifacts,
      required this.process,
      required this.count,
      required this.price});
}
