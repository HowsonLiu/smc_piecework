class Period {
  String name;
  DateTime createTime;
  Period({required this.name, required this.createTime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createTime': createTime.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return "Period{name: $name, createTime: $createTime}";
  }
}