class Employee {
  final int id;
  final String name;
  Employee.fromMap({required this.id, required this.name});
  Employee.fromFlat(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  @override 
  String toString() {
    return 'Employee{id: $id, name: $name}';
  }
}
