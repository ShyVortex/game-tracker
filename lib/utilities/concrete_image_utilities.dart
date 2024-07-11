import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'abstract/image_utilities.dart';

class ConcreteImageUtilities extends ImageUtilities {
  static final ConcreteImageUtilities instance = ConcreteImageUtilities();

  @override
  Future<File> writeAsBytes(
      List<int> bytes, {
        FileMode mode = FileMode.write,
        bool flush = false,
      }) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(tempPath);
    return file.writeAsBytes(bytes, mode: mode, flush: flush);
  }
}
