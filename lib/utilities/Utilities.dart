import 'dart:async';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';

class Utilities {
  
static Future<String> hashPassword(String password) async {
  // Hash la password asincronamente
  return  Future(() => BCrypt.hashpw(password, BCrypt.gensalt()));
}

static Future<bool> verifyPassword(String password, String hashedPassword) async {
  // Verifica la password asincronamente
  return await Future(() => BCrypt.checkpw(password, hashedPassword));
}
static String _hashPasswordSync(String password) {
  // Esegui l'hashing della password in modo sincrono
  return BCrypt.hashpw(password, BCrypt.gensalt());
}

static Future<String> hashPasswordAsync(String password) {
  return compute(_hashPasswordSync, password);
}
  static bool isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  RegExp regExp = RegExp(emailPattern);

  return !regExp.hasMatch(email);
}

}