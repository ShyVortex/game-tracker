import 'dart:convert';
import 'dart:math';
import 'package:pointycastle/pointycastle.dart';

class Utilities {
  

 static String generateSalt([int length = 32]) {
  final Random _random = Random.secure();
  final List<int> salt = List<int>.generate(length, (i) => _random.nextInt(256));
  return base64Url.encode(salt);
}

  static String hashPassword(String password, String salt) {
  final pbkdf2 = KeyDerivator('SHA-1/HMAC/PBKDF2');
  final params = Pbkdf2Parameters(utf8.encode(salt), 10000, 32);
  pbkdf2.init(params);
  final key = pbkdf2.process(utf8.encode(password));
  return base64Url.encode(key);
}
  static bool isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  RegExp regExp = RegExp(emailPattern);

  return !regExp.hasMatch(email);
}

}