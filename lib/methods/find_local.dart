import 'package:path_provider/path_provider.dart';

Future<String> get findLocalPath async {
  return (await getApplicationDocumentsDirectory()).path;
}
