import 'package:notary/models/type_notarization.dart';

class Session {
  String id;
  TypeNotarization typeNotarization;
  String state;
  String stages;
  String sessionToken;
  String sessionFileName;
  String sessionFilePath;
  List<String> images;
  String socketRoomName;
  int fileSize;
  String twilioRoomName;
  String sid;

  Session();

  Session.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        typeNotarization = json['typeNotarization'] == null
            ? null
            : new TypeNotarization.fromJson(json['typeNotarization']),
        state = json['state'],
        stages = json['stages'],
        sessionToken = json['sessionToken'],
        sessionFileName = json['sessionFileName'],
        sessionFilePath = json['sessionFilePath'],
        images =
            List<String>.from(json['images']).map((image) => image).toList(),
        socketRoomName = json['socketRoomName'],
        fileSize = json['fileSize'],
        twilioRoomName = json['twilioRoomName'],
        sid = json['sid'];

  @override
  String toString() {
    return 'Session{id: $id, typeNotarization: $typeNotarization, state: $state, stages: $stages, sessionToken: $sessionToken, sessionFileName: $sessionFileName, sessionFilePath: $sessionFilePath, images: $images, socketRoomName: $socketRoomName, fileSize: $fileSize, twilioRoomName: $twilioRoomName, sid: $sid}';
  }
}
