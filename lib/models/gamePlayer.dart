

import 'package:game_tracker/models/game.dart';

class Gameplayer {
     int? _id;
     int? _trofeiOttenuti;
     int? _valutazione;
     int? _oreDiGioco;
     bool? _preferito;
     Game? _game;
     String? _luogoCompletamento;
     List<String>? _immagini;
     Gameplayer.withParameters({required int? id,required int? trofeiOttenuti,required int? valutazione, required int? oreDiGioco,required bool? preferito,required Game? game, required String? luogoCompletamento, required List<String?> immagini}){
      _id = id;
      _trofeiOttenuti = trofeiOttenuti;
      _valutazione = valutazione;
      _oreDiGioco = oreDiGioco;
      _preferito = preferito;
      _game = game;
      _immagini = [];
     }
     Gameplayer(){
      _trofeiOttenuti = 0;
      _valutazione = 0;
      _oreDiGioco = 0;
      _preferito = false;
      _luogoCompletamento = "";
      _immagini = [];
     }

     int? get id => _id;
     int? get trofeiOttenuti => _trofeiOttenuti;
     int? get valutazione => _valutazione;
     int? get oreDiGioco => _oreDiGioco;
     bool? get preferito => _preferito;
     Game? get game => _game;
     List<String>? get immagini => _immagini;
     String? get luogoCompletamento => _luogoCompletamento;

      
      set trofeiOttenuti(int? value){
      _trofeiOttenuti = value;
    }
      set valutazione(int? value){
      _valutazione = value;
    }
      set oreDiGioco(int? value){
      _oreDiGioco = value;
    }
      set preferito(bool? value){
      _preferito = value;
    }
    set luogoCompletamento(String? value){
      _luogoCompletamento = value;
    }
    set immagini(List<String>? value){
      _immagini = value;
    }
    Map<String, dynamic> toJson() => {
    'id': _id,
    'trofeiOttenuti': _trofeiOttenuti,
    'valutazione': _valutazione,
    "oreDiGioco" : _oreDiGioco,
    "preferito" : _preferito,
    "luogoCompletamento" : _luogoCompletamento,
    "immagini" : _immagini
  };
  factory Gameplayer.fromJson(Map<String, dynamic> json) {
    return Gameplayer.withParameters(
      id: json['id'],
      trofeiOttenuti: json['trofeiOttenuti'],
      valutazione: json['valutazione'],
      oreDiGioco: json['oreDiGioco'],
      preferito: json['preferito'],
      game: Game.fromJson(json['game']),
      luogoCompletamento: json['luogoCompletamento'],
      immagini : List<String>.from(json['immagini'])
    );
  }

}