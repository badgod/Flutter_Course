import 'dart:math';

class Circle {
  double _radius;

  //Constructor
  Circle(this._radius);

  //set Radius
  set radius(double radius) {
    if (radius >= 0) {
      _radius = radius;
    } else {
      print("Radius cannot be negative.");
    }
  }

  double get radius => _radius;
  /*
  double get radius {
    return _radius;
  } 
  */

  double get area => pi * _radius * _radius;

  double get circumference {
    return 2 * pi * _radius;
  }
}

void main() {
  var circle = Circle(5.0);
  print("Radius: ${circle.radius}");
  print("Area: ${circle.area}");
  print("Circumference: ${circle.circumference}");

  circle.radius = 10.0;
  print("Updated Radius: ${circle.radius}");
  print("Updated Area: ${circle.area}");
  print("Updated Circumference: ${circle.circumference}");

  circle.radius = -3.0; // This should trigger the negative radius message
}
