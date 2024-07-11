import 'dart:async';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';

class Utilities {

static final Map<String,int> _valutazioneMap  = {
    '0/10': 0 ,
    '1/10': 1 ,
    '2/10': 2 ,
    '3/10': 3 ,
    '4/10': 4 ,
    '5/10': 5 ,
    '6/10': 6 ,
    '7/10': 7,
    '8/10': 8,
    '9/10': 9,
    '10/10': 10
 };


static Future<String> hashPassword(String password) async {
  return BCrypt.hashpw(password, BCrypt.gensalt());
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
static int? valutazioneIntValue(String? key){
  return _valutazioneMap[key];
}

}