
class Game {
  int? _id;
  String? _nome;
  String? _sviluppatore;
  List<String>? _piattaforme;
  String? _immagineURL;
  int? _trofeiTotali;
  bool? isSelected;
  bool? _isNetworkImage;

  Game.withParameters({required int? id,required String? nome,required String? sviluppatore,required List<String>? piattaforme,required String? immagineURL,required int? trofeiTotali,required bool? isNetworkImage}){
    _id = id;
    _nome = nome;
    _sviluppatore = sviluppatore;
    _piattaforme = piattaforme;
    _immagineURL = immagineURL;
    _trofeiTotali = trofeiTotali;
    _isNetworkImage = isNetworkImage;
    isSelected = false;
  }
  Game(){
    _piattaforme = [];
  }
  int? get id => _id;
  String? get nome => _nome;
  String? get sviluppatore => _sviluppatore;
  List<String>? get piattaforme => _piattaforme;
  String? get immagineURL => _immagineURL;
  int? get trofeiTotali => _trofeiTotali;
  bool? get isNetworkImage => _isNetworkImage;


  set nome(String? value){
      _nome = value;
  }
  set sviluppatore(String? value){
    _sviluppatore = value;
  }
  set piattaforme(List<String>? value){
    _piattaforme = value;
  }
  set trofeiTotali(int? value){
    _trofeiTotali = value;
  }
  set immagineURL(String? value){
    _immagineURL = value;
  }
  set isNetworkImage(bool? value){
    _isNetworkImage = value;
  }

   Map<String, dynamic> toJson() => {
    'id': _id,
    'nome': _nome,
    'sviluppatore': _sviluppatore,
    'piattaforme': _piattaforme,
    "immagineURL": _immagineURL,
    "trofeiTotali" : _trofeiTotali,
    "networkImage": _isNetworkImage
  };
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game.withParameters(
      id: json['id'],
      nome: json['nome'],
      sviluppatore: json['sviluppatore'],
      piattaforme: List<String>.from(json['piattaforme']),
      immagineURL: json['immagineURL'],
      trofeiTotali: json["trofeiTotali"],
      isNetworkImage: json["networkImage"]
    );
  }
   @override
  String toString() {
    return 'Game{id: $_id, nome: $_nome, sviluppatore: $_sviluppatore, piattaforme: $_piattaforme, immagineURL: $_immagineURL, trofeiTotali: $_trofeiTotali, isNetworkImage: $_isNetworkImage, isSelected: $isSelected}';
  }

}