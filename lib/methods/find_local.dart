import 'dart:io';
import 'package:path_provider/path_provider.dart';


Future<String> get findLocalPath async {
  String directory;
  if (Platform.isAndroid) {
    directory = '/storage/emulated/0/Download';
  } else {
    directory = (await getApplicationDocumentsDirectory()).path;
  }
  return directory;
}
