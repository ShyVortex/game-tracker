import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageUtilities {

  static ImageUtilities instance = ImageUtilities();

  String encodeImage(File imageFile) {
    // Legge i bytes dall'oggetto file
    List<int> bytes = imageFile.readAsBytesSync();

    // Codifica i bytes in una stringa base64
    String base64String = base64Encode(bytes);

    return base64String;
  }

  Uint8List decodeImage(String b64Img) {
    // Decodifica il base64 e riottieni i bytes
    Uint8List bytes = base64Decode(b64Img);

    // Restituisci i bytes dell'immagine
    return bytes;
  }
}