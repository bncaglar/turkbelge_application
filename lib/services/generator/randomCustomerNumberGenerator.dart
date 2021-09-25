import 'dart:math';

String generateCustomerNumber({
  bool isNumber = true,
}) {
  final length = 6;
  final number = '0123456789';

  String chars = "";
  if (isNumber) chars += '$number';

  return List.generate(length, (index) {
    final indexRandom = Random.secure().nextInt(chars.length);
    return chars[indexRandom];
  }).join('');
}
