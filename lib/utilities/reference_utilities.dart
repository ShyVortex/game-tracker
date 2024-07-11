import '../models/player.dart';

class ReferenceUtilities {
  static late Player _activePlayer;

  static Player getActivePlayer() {
    return _activePlayer;
  }
  
  static void setActivePlayer(Player player) {
    _activePlayer = player;
  }
}