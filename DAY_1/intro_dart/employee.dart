class Employee {
  int id = 0;
  String name = '';
  double salary = 0.0;
  String? email;
}

void main() {
  var emp = Employee();
  emp.id = 1;
  emp.name = 'John Doe';
  emp.salary = 50000.0;
  emp.email = 'jack@mail.com';

  var emp2 = Employee()
    ..id = 2
    ..name = 'Jane Smith'
    ..salary = 60000.0;

  print('Employee 1: ${emp.id}, ${emp.name}, ${emp.salary}, ${emp.email}');
  print('Employee 2: ${emp2.id}, ${emp2.name}, ${emp2.salary}, ${emp2.email}');
}
