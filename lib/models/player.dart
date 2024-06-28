

import 'package:game_tracker/models/Piattaforma.dart';
import 'package:game_tracker/models/sesso.dart';

class Player {
  int? _id;
  String? _username;
  String? _email;
  String? _password;
  Sesso? _sesso;
  String? _birthday;
  Piattaforma? _piattaformaPreferita;

  Player(){}

  int? get id => _id;
  String? get username => _username;
  String? get password => _password;
  String? get email => _email;
  Sesso? get sesso => _sesso;
  String? get birthday => _birthday;
  Piattaforma? get piattaforma => _piattaformaPreferita;

  set username(String? value){
      _username = value;
  }
  set password(String? value){
    _password = value;
  }
  set sesso(Sesso? value){
    _sesso = value;
  }
  set birthday(String? value){
    _birthday = value;
  }
  set piattaforma(Piattaforma? value){
    _piattaformaPreferita = value;
  }
  set email(String? value){
    _email = value;
  }

  Map<String, dynamic> toJson() => {
    'username': _username,
    'email': _email,
    'password': _password,
    'sesso': _sesso,
    'birthday': _birthday,
    'piattaformaPreferita': _piattaformaPreferita
  };
}