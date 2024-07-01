import 'package:game_tracker/models/Piattaforma.dart';

class Game {
  int? _id;
  String? _nome;
  String? _sviluppatore;
  List<String>? _piattaforme;
  String? _immagineURL;
  bool? isSelected;

  Game.withParameters({required int? id,required String? nome,required String? sviluppatore,required List<String>? piattaforme,required String? immagineURL}){
    _id = id;
    _nome = nome;
    _sviluppatore = sviluppatore;
    _piattaforme = piattaforme;
    _immagineURL = immagineURL;
    isSelected = false;
  }
  int? get id => _id;
  String? get nome => _nome;
  String? get sviluppatore => _sviluppatore;
  List<String>? get piattaforme => _piattaforme;
  String? get immagineURL => _immagineURL;

  set nome(String? value){
      _nome = value;
  }
  set sviluppatore(String? value){
    _sviluppatore = value;
  }
  set piattaforme(List<String>? value){
    _piattaforme = value;
  }

   Map<String, dynamic> toJson() => {
    'id': _id,
    'nome': _nome,
    'sviluppatore': _sviluppatore,
    'piattaforme': _piattaforme,
  };
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game.withParameters(
      id: json['id'],
      nome: json['nome'],
      sviluppatore: json['sviluppatore'],
      piattaforme: List<String>.from(json['piattaforme']),
      immagineURL: json['immagineURL']
    );
  }

}