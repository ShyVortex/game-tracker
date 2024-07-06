import 'dart:io';

import 'package:game_tracker/models/game.dart';

class Gameplayer {
     int? _id;
     int? _trofeiTotali;
     int? _trofeiOttenuti;
     int? _valutazione;
     int? _oreDiGioco;
     bool? _preferito;
     Game? _game;
     String? _luogoCompletamento;
     List<File>? _immagini;
     Gameplayer.withParameters({required int? id,required int? trofeiTotali,required int? trofeiOttenuti,required int? valutazione, required int? oreDiGioco,required bool? preferito,required Game? game, required String? luogoCompletamento}){
      _id = id;
      _trofeiTotali = trofeiTotali;
      _trofeiOttenuti = trofeiOttenuti;
      _valutazione = valutazione;
      _oreDiGioco = oreDiGioco;
      _preferito = preferito;
      _game = game;
      _immagini = [];
     }
     Gameplayer();
     int? get id => _id;
     int? get trofeiTotali => _trofeiTotali;
     int? get trofeiOttenuti => _trofeiOttenuti;
     int? get valutazione => _valutazione;
     int? get oreDiGioco => _oreDiGioco;
     bool? get preferito => _preferito;
     Game? get game => _game;
     List<File>? get immagini => _immagini;
     String? get luogoCompletamento => _luogoCompletamento;

      set trofeiTotali(int? value){
      _trofeiTotali = value;
    }
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
    set immagini(List<File>? value){
      _immagini = value;
    }
    Map<String, dynamic> toJson() => {
    'id': _id,
    'trofeiTotali': _trofeiTotali,
    'trofeiOttenuti': _trofeiOttenuti,
    'valutazione': _valutazione,
    "oreDiGioco" : _oreDiGioco,
    "preferito" : _preferito,
    "luogoCompletamento" : _luogoCompletamento
  };
  factory Gameplayer.fromJson(Map<String, dynamic> json) {
    return Gameplayer.withParameters(
      id: json['id'],
      trofeiTotali: json['trofeiTotali'],
      trofeiOttenuti: json['trofeiOttenuti'],
      valutazione: json['valutazione'],
      oreDiGioco: json['oreDiGioco'],
      preferito: json['preferito'],
      game: Game.fromJson(json['game']),
      luogoCompletamento: json['luogoCompletamento']
    );
  }

}