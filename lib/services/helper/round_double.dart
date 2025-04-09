import 'dart:math';

double roundDouble(double value) {
  final factor = pow(10, 2);
  return (value * factor).round() / factor;
}
