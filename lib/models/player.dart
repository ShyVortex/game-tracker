import 'package:game_tracker/models/genere.dart';


class Player {
  int? _id;
  String? _username;
  String? _email;
  String? _password;
  Genere? _genere;
  String? _birthday;
  String? _piattaformaPreferita;
  String? _giocoPreferito;
   
  Player.withParameters(
      {
    required int? id,
    required String? username,
    required String? email,
    required String? password,
    required Genere? genere,
    required String? birthday,
    required String? piattaformaPreferita,
    required String? giocoPreferito,
      })
  {
    _id = id;
    _username = username;
    _email = email;
    _password = password;
    _genere = genere;
    _birthday = birthday;
    _piattaformaPreferita = piattaformaPreferita;
    _giocoPreferito = giocoPreferito;
  }
  Player();

  int? get id => _id;
  String? get username => _username;
  String? get password => _password;
  String? get email => _email;
  Genere? get genere => _genere;
  String? get birthday => _birthday;
  String? get piattaforma => _piattaformaPreferita;
  String? get giocoPreferito => _giocoPreferito;

  set username(String? value){
      _username = value;
  }
  set email(String? value){
    _email = value;
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
  set piattaforma(String? value){
    _piattaformaPreferita = value;
  }
  set giocoPreferito(String? value) {
    _giocoPreferito = value;
  }

  Map<String, dynamic> toJson() => {
    'username': _username,
    'email': _email,
    'password': _password,
    'birthday': _birthday,
    'piattaformaPreferita': _piattaformaPreferita,
    'giocoPreferito': _giocoPreferito
  };
   factory Player.fromJson(Map<String, dynamic> json) {
    return Player.withParameters(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
        genere: json['genere'] == null
            ? json['genere']
            : GenereExtension.genereFromBackend(json['genere']),
      birthday: json['birthday'],
      piattaformaPreferita : json['piattaformaPreferita'],
      giocoPreferito: json['giocoPreferito']
    );
  }
}