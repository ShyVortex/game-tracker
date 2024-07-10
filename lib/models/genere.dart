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
}