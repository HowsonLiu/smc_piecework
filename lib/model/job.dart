class Job {
  DateTime? ticket;
  String period = "";
  String worker = "";
  String artifacts = "";
  String process = "";
  double price = 0;
  int count = 0;
  int valid = 1;

  Job(
      {this.ticket,
      required this.period,
      required this.worker,
      required this.artifacts,
      required this.process,
      required this.count,
      required this.price,
      required this.valid});

  Map<String, dynamic> toMap() {
    return {
      'ticket': ticket?.millisecondsSinceEpoch,
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
