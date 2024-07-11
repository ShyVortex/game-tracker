import 'dart:convert';
import 'dart:io';

abstract class ImageUtilities {
  Future<String> encodeImage(File imageFile) async {
    // Legge i bytes dall'oggetto file
    List<int> bytes = (await imageFile.readAsBytes());

    // Codifica i bytes in una stringa base64
    String base64String = base64.encode(bytes);

    return base64String;
  }

  File decodeImage(String b64Image) {
    // Decodifica l'immagine in bytes
    List<int> bytes = base64.decode(b64Image);

    // Dai bytes costruisce il file
    File imageFile = writeAsBytes(bytes) as File;

    return imageFile;
  }

  Future<File> writeAsBytes(
      List<int> bytes,
      {FileMode mode = FileMode.write,
        bool flush = false}
  );
}