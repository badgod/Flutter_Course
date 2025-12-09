void main() {
  print('Hello, Dart!');

  int num0 = 5;
  var num1 = 10;
  double num2 = 15.5;

  print("Number 0 is: $num0");
  print("Number 1 is: " + num1.toString());
  print("Number 2 is: " + num2.toString());

  //ตัวแปรคงที่
  const pi = 3.14;
  print("ค่าคงที่ pi คือ: $pi");

  String pitxt = "ค่าของ pi คือ " + pi.toString();

  List<String> fruits = ['Apple', 'Banana', 'Cherry'];
  for (var fruit in fruits) {
    print("ผลไม้: $fruit");
  }

  printOneToTen();
}

void printOneToTen() {
  for (int i = 1; i <= 10; i++) {
    print(i);
  }
}
