import 'package:notary/enum/stage_enum.dart';
import 'package:notary/models/type_notarization.dart';

class Session {
  String id;
  TypeNotarization typeNotarization;
  String state;
  String encryptedFile;
  Stage stage;
  String sessionToken;
  String sessionFileName;
  String sessionFilePath;
  List<String> images;
  String socketRoomName;
  int fileSize;
  String twilioRoomName;

  Session();

  Session.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        typeNotarization = json['typeNotarization'] == null ||
                json['typeNotarization'].runtimeType == String
            ? null
            : new TypeNotarization.fromJson(json['typeNotarization']),
        encryptedFile =
        json['encryptedFile'] != null ? json['encryptedFile'] : null,
        state = json['state'],
        stage = Stage.values
            .firstWhere((e) => e.toString() == 'Stage.' + json['stages']),
        sessionToken = json['sessionToken'],
        sessionFileName = json['sessionFileName'],
        sessionFilePath = json['sessionFilePath'],
        images =
            List<String>.from(json['images']).map((image) => image).toList(),
        socketRoomName = json['socketRoomName'],
        fileSize = json['fileSize'],
        twilioRoomName = json['twilioRoomName'];

  @override
  String toString() {
    return 'Session{id: $id, typeNotarization: $typeNotarization, state: $state, stage: $stage, sessionToken: $sessionToken, sessionFileName: $sessionFileName, sessionFilePath: $sessionFilePath, images: $images, socketRoomName: $socketRoomName, fileSize: $fileSize, twilioRoomName: $twilioRoomName}';
  }
}
