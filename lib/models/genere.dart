enum Genere {
  MASCHIO,
  FEMMINA,
  NON_BINARIO
}

extension GenereExtension on Genere {
  String get name {
    switch (this) {
      case Genere.MASCHIO:
        return "Maschio";
      case Genere.FEMMINA:
        return "Femmina";
      case Genere.NON_BINARIO:
        return "Non binario";
      default:
        return "";
    }
  }

  String get backendValue {
    switch (this) {
      case Genere.MASCHIO:
        return "MASCHIO";
      case Genere.FEMMINA:
        return "FEMMINA";
      case Genere.NON_BINARIO:
        return "NON_BINARIO";
      default:
        return "";
    }
  }


  // Funzione helper che converte i valori del backend in quelli del frontend
  static Genere? genereFromBackend(String value) {
    switch (value) {
      case "MASCHIO":
        return Genere.MASCHIO;
      case "FEMMINA":
        return Genere.FEMMINA;
      case "NON BINARIO":
        return Genere.NON_BINARIO;
      default:
        return null;
    }
  }
}