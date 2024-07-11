
import 'package:game_tracker/models/Piattaforma.dart';
import 'package:game_tracker/models/genere.dart';

class Player {
  int? _id;
  String? _username;
  String? _email;
  String? _password;
  Genere? _genere;
  String? _birthday;
  Piattaforma? _piattaformaPreferita;
   
  Player.withParameters({required int? id,required String? username, required String? email,required String? password,required Genere? genere,required String? birthday,required Piattaforma? piattaformaPreferita}){
    _id = id;
    _username = username;
    _email = email;
    _password = password;
    _genere = genere;
    _birthday = birthday;
    _piattaformaPreferita = piattaformaPreferita;
  }
  Player();

  int? get id => _id;
  String? get username => _username;
  String? get password => _password;
  String? get email => _email;
  Genere? get genere => _genere;
  String? get birthday => _birthday;
  Piattaforma? get piattaforma => _piattaformaPreferita;

  set username(String? value){
      _username = value;
  }
  set password(String? value){
    _password = value;
  }
  set genere(Genere? value){
    _genere = value;
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
    'sesso': _genere,
    'birthday': _birthday,
    'piattaformaPreferita': _piattaformaPreferita
  };
   factory Player.fromJson(Map<String, dynamic> json) {
    return Player.withParameters(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password:json['password'],
      genere: json['sesso'],
      birthday: json['birthday'],
      piattaformaPreferita : json['piattaformaPreferita']
    );
  }
}