class Job {
  DateTime ticket;
  String period = "";
  String worker = "";
  String artifacts = "";
  String process = "";
  double price = 0;
  int count = 0;
  int valid = 1;

  Job(
      {required this.ticket,
      required this.period,
      required this.worker,
      required this.artifacts,
      required this.process,
      required this.count,
      required this.price,
      required this.valid});

  Job.fromTempJob(
      {required TempJob tempJob, required this.ticket, required this.valid}) {
    period = tempJob.period;
    worker = tempJob.worker;
    artifacts = tempJob.artifacts;
    process = tempJob.process;
    price = tempJob.price;
    count = tempJob.count;
  }

  Map<String, dynamic> toMap() {
    return {
      'ticket': ticket.millisecondsSinceEpoch,
      'period': period,
      'worker': worker,
      'artifacts': artifacts,
      'process': process,
      'price': price,
      'count': count,
      'valid': valid
    };
  }

  @override
  String toString() {
    return "$worker($count)";
  }
}

// the job hasn't record
class TempJob {
  String period = "";
  String worker = "";
  String artifacts = "";
  String process = "";
  double price = 0;
  int count = 0;

  TempJob({
    required this.period,
    required this.worker,
    required this.artifacts,
    required this.process,
    required this.price,
    required this.count,
  });
}
