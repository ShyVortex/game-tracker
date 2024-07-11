import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'abstract/image_utilities.dart';

class ConcreteImageUtilities extends ImageUtilities {
  static ConcreteImageUtilities instance = ConcreteImageUtilities();

  @override
  Future<File> writeAsBytes(
      List<int> bytes, {
        FileMode mode = FileMode.write,
        bool flush = false,
      }) async {
    // Ottieni cartella temporanea
    Directory tempDir = await getTemporaryDirectory();
    // Crea un file univoco
    String tempPath = '${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(tempPath);
    // Scrivi i bytes su quel file
    return await file.writeAsBytes(bytes, mode: mode, flush: flush);
  }
}
