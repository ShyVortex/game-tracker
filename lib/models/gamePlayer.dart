import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/utilities/login_utilities.dart';

class GamePlayer {
     int? _id;
     int? _trofeiOttenuti;
     int? _valutazione;
     int? _oreDiGioco;
     bool? _preferito;
     Game? _game;
     String? _luogoCompletamento;
     List<String>? _immagini;
     String? _dataCompletamento;
     GamePlayer.withParameters({required int? id,required int? trofeiOttenuti,required int? valutazione, required int? oreDiGioco,required bool? preferito,required Game? game, required String? luogoCompletamento, required List<String>? immagini,required String? dataCompletamento}){
      _id = id;
      _trofeiOttenuti = trofeiOttenuti;
      _valutazione = valutazione;
      _oreDiGioco = oreDiGioco;
      _preferito = preferito;
      _game = game;
      _immagini = immagini;
      _dataCompletamento = dataCompletamento;
      _luogoCompletamento = luogoCompletamento;
     }
     GamePlayer(){
      _trofeiOttenuti = 0;
      _valutazione = 0;
      _oreDiGioco = 0;
      _preferito = false;
      _luogoCompletamento = "";
      _dataCompletamento = "";
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
     String? get dataCompletamento => _dataCompletamento;


      set trofeiTotali(int? value){
      trofeiTotali = value;
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
    set immagini(List<String>? value){
      _immagini = value;
    }
    set dataCompletamento(String? value){
      _dataCompletamento = value;
    }
    Map<String, dynamic> toJson() => {
    'id': _id,
    'trofeiOttenuti': _trofeiOttenuti,
    'valutazione': _valutazione,
    "oreDiGioco" : _oreDiGioco,
    "preferito" : _preferito,
    "luogoCompletamento" : _luogoCompletamento,
    "immagini" : _immagini,
    "dataCompletamento": _dataCompletamento
  };
  factory GamePlayer.fromJson(Map<String, dynamic> json) {
    return GamePlayer.withParameters(
      id: json['id'],
      trofeiOttenuti: json['trofeiOttenuti'],
      valutazione: json['valutazione'],
      oreDiGioco: json['oreDiGioco'],
      preferito: json['preferito'],
      game: Game.fromJson(json['game']),
      luogoCompletamento: json['luogoCompletamento'],
      immagini : List<String>.from(json['immagini']),
      dataCompletamento: json['dataCompletamento']
    );
  }
   @override
  String toString() {
    return 'GamePlayer(_id: $_id, '
           '_trofeiOttenuti: $_trofeiOttenuti, '
           '_valutazione: $_valutazione, '
           '_oreDiGioco: $_oreDiGioco, '
           '_preferito: $_preferito, '
           '_game: $_game, '
           '_immagini: $_immagini, '
           '_dataCompletamento: $_dataCompletamento,'
           '_luogoCompletamento: $_luogoCompletamento';
  }
   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamePlayer &&
          id == other.id &&
          trofeiOttenuti == other.trofeiOttenuti &&
          valutazione == other.valutazione &&
          oreDiGioco == other.oreDiGioco &&
          preferito == other.preferito &&
          game == other.game &&
          LoginUtilities.compareTwoListString(immagini!, other.immagini!)! &&
          dataCompletamento == other.dataCompletamento &&
          luogoCompletamento == other.luogoCompletamento;

  @override
  int get hashCode =>
      id.hashCode ^
      trofeiOttenuti.hashCode ^
      valutazione.hashCode ^
      oreDiGioco.hashCode ^
      preferito.hashCode ^
      game.hashCode ^
      immagini.hashCode ^
      dataCompletamento.hashCode;
}
