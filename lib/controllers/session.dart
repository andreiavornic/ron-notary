import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/enum/stage_enum.dart';
import 'package:notary/methods/find_local.dart';
import 'package:notary/models/font_family.dart';
import 'package:notary/models/point.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/models/user.dart';
import 'package:notary/services/dio_service.dart';

import 'package:path/path.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:pdf_render/pdf_render.dart' as Render;
import 'package:image/image.dart' as imglib;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

class SessionController extends GetxController {
  final _session = Rx<Session>(null);
  final _box = GetStorage();
  final Rx<File> _fileEncrypted = Rx<File>(null);
  final Rx<String> _journalId = Rx<String>(null);
  final Rx<String> _sessionId = Rx<String>(null);
  final _recipients = RxList<Recipient>([]);
  final _recipientVideo = RxList<Recipient>([]);
  final _points = RxList<Point>([]);
  RxList<TypeNotarization> _notarizations = RxList<TypeNotarization>();

  Rx<String> _sessionFileName = Rx<String>(null);
  Rx<String> _sessionFilePath = Rx<String>(null);

  Rx<String> get sessionFileName => _sessionFileName;

  Rx<Session> get session => _session;

  RxList<TypeNotarization> get notarizations => _notarizations;

  RxList<Recipient> get recipientVideo => _recipientVideo;

  RxList<Recipient> get recipients => _recipients;

  RxList<Point> get points => _points;

  @override
  void onInit() {
    // getSession();
    super.onInit();
  }

  reset() {
    _points.clear();
    update();
  }

  getSession() async {
    try {
      dio.Response resDio = await makeRequest('session', 'GET', null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = new Session.fromJson(extracted['data']['session']);
      _recipients.clear();
      _recipientVideo.clear();
      _points.clear();
      _getUserData(extracted['data']['user']);
      extracted['data']['session']['recipients'].forEach((json) {
        _recipients.add(new Recipient.fromJson(json));
        _recipientVideo.add(new Recipient.fromJson(json));
      });
      extracted['data']['session']['points'].forEach((json) {
        _points.add(new Point.fromJson(json));
      });
      _sessionId.value = _session.value.id;
      _sessionFileName.value = extracted['data']['session']['sessionFileName'];
      _sessionFilePath.value = extracted['data']['session']['sessionFilePath'];

      final prefs = GetStorage();
      prefs.write(
          "SOCKET_ROOM", extracted['data']['session']['socketRoomName']);
      update();
    } catch (err) {
      _session.value = null;
      update();
      // throw err;
    }
  }

  _getUserData(Map<String, dynamic> data) {
    User _user = User.fromJsonRecipient(data);

    Recipient _userRecipient = new Recipient(
      id: _user.id,
      firstName: _user.firstName,
      lastName: _user.lastName,
      isActive: true,
      type: 'NOTARY',
      color: Color(0xFFFFC700),
      states: [],
    );
    addUserRecipient(_userRecipient);
  }

  Future<void> createSession(PlatformFile file) async {
    try {
      File fetchedFile = new File(file.path);
      String originalname = basename(fetchedFile.path);
      // final form = FormData({
      //   'file': MultipartFile(fetchedFile, filename: originalname),
      // });
      // print(form);
      //
      //  dio.Response resDio = await _dioService.postData('session', form);
      // print(response.status);
      // print(response.body);
      // var extracted = resDio.data;
      // print(extracted);
      // if (!extracted['success']) {
      //   throw extracted['message'];
      // }
      // _session.value = new Session.fromJson(extracted['data']);
      // final prefs = GetStorage();
      // prefs.write("SOCKET_ROOM", extracted['data']['socketRoomName']);

      final box = GetStorage();
      var url = dotenv.env['URL'];
      var token = box.read("TOKEN");
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-type": 'multipart/form-data'
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/session'),
      )..headers.addAll(headers);

      request
        ..files.add(await http.MultipartFile.fromPath('file', fetchedFile.path,
            filename: originalname,
            contentType: MediaType('application', 'pdf')));

      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      var extracted = json.decode(respStr) as Map<String, dynamic>;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = new Session.fromJson(extracted['data']);

      final prefs = GetStorage();
      prefs.write("SOCKET_ROOM", extracted['data']['socketRoomName']);

      // var postUri = Uri.parse("http://127.0.0.1:4040/api/v1/session");
      // var request = new http.MultipartRequest("POST", postUri);
      // request.fields['user'] = 'blah';
      // print(Uri.parse(file.path));
      // request.files.add(new http.MultipartFile.fromBytes(
      //     'file', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
      //     contentType: new MediaType('image', 'jpeg')));
      //
      // request.send().then((response) {
      //   print(response);
      //   if (response.statusCode == 200) print("Uploaded!");
      // });
      update();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateSession(
      String typeNotarization, String documentTitle) async {
    try {
      dio.Response resDio = await makeRequest('session', "PUT", {
        "typeNotarization": typeNotarization,
        "sessionFileName": documentTitle,
      });
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }

      _session.value.typeNotarization =
          new TypeNotarization.fromJson(extracted['data']['typeNotarization']);
      _session.value.sessionFileName = extracted['data']['sessionFileName'];
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateStage(String stage) async {
    try {
      dio.Response resDio = await makeRequest(
        'session/${_session.value.id}',
        'POST',
        {'stage': stage},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }

      updateStageByString(stage);
    } catch (err) {
      throw err;
    }
  }

  updateStageByString(String stage) {
    _session.update((val) {
      val.stage =
          Stage.values.firstWhere((e) => e.toString() == 'Stage.' + stage);
    });
    update();
  }

  Future<void> deleteSession() async {
    try {
      dio.Response resDio = await makeRequest('session', 'DELETE', null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = null;
      final prefs = GetStorage();
      prefs.remove("SOCKET_ROOM");
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getTypeNotarization() async {
    try {
      dio.Response resDio = await makeRequest('type-notarization', "GET", null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _notarizations.clear();
      extracted['data'].forEach((json) {
        _notarizations.add(new TypeNotarization.fromJson(json));
      });
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> startSession() async {
    try {
      String status = "START";
      dio.Response resDio = await makeRequest(
        'session/$status',
        "PUT",
        {},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value.state = status;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> processSession() async {
    try {
      await removeToken();
      String status = "IN_PROCESS";
      dio.Response resDio = await makeRequest(
        'session/$status',
        "PUT",
        {},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value.state = status;
      await saveToken(extracted['data']['token']);
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> finishSession() async {
    try {
      await removeToken();
      String status = "ENCRYPTING";
      dio.Response resDio = await makeRequest(
        'session/$status',
        "PUT",
        {},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value.state = status;
      await removeToken();
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> cancelSession() async {
    try {
      await removeToken();
      String status = "CANCELLED";
      dio.Response resDio = await makeRequest(
        'session/$status',
        "PUT",
        {},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = null;
      await removeToken();
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> encryptFile(String _passwordEncrypting) async {
    try {
      String status = "FINISHED";
      dio.Response resDio = await makeRequest(
        'session/$status',
        "PUT",
        {"password": _passwordEncrypting},
      );

      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _journalId.value = extracted['data'];
      await removeToken();
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> downloadFile() async {
    try {
      dio.Response resDio = await makeRequest(
        'session/${_sessionId.value}',
        "GET",
        null,
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }

      String dirLoc = await findLocalPath;
      String filePath = '$dirLoc/${_sessionFilePath.value}';

      File file = new File(filePath);
      var buffer = extracted['data']['data'] as List<dynamic>;
      await file.writeAsBytes(buffer.cast<int>());
      _fileEncrypted.value = file;
      _session.value = null;
      update();
      await openFile();
    } catch (err) {
      throw err;
    }
  }

  addUserRecipient(Recipient recipient) {
    if (_recipientVideo.any((element) => element.id == recipient.id)) {
      return;
    }
    _recipientVideo.insert(0, recipient);
    update();
  }

  updateRecipients(data) {
    int index =
        _recipients.indexWhere((recipient) => recipient.id == data['id']);
    if (index >= 0) {
      _recipients[index].states =
          List<String>.from(data['states']).map((state) => state).toList();
    }
    update();
  }

  activateRecipient(Recipient recipient) {
    _recipientVideo.forEach((element) {
      element.isActive = false;
    });
    int index =
        _recipientVideo.indexWhere((element) => element.id == recipient.id);
    if (index > -1) {
      _recipientVideo[index].isActive = true;
    }
    update();
  }

  updatePoints(data) {
    data.forEach((element) {
      int index = _points.indexWhere((point) => point.id == element['id']);
      if (index >= 0) {
        _points[index].isSigned = element['isSigned'];
      }
    });
    update();
  }

  addSign() async {
    try {
      dio.Response resDio = await makeRequest(
        'point',
        "PUT",
        {'type': 'ALL'},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  addStamp() async {
    try {
      dio.Response resDio = await makeRequest(
        'point',
        "PUT",
        {'type': 'STAMP'},
      );
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  shareFile() async {
    await Share.shareFiles(
      [_fileEncrypted.value.path],
      subject: _sessionFileName.value,
    );
  }

  get fileEncrypted => _fileEncrypted;

  Future<void> saveToken(String token) async {
    await _box.write('TWILIO_TOKEN', token);
  }

  Future<void> removeToken() async {
    await _box.remove('TWILIO_TOKEN');
  }

  Future<MemoryImage> formatImage() async {
    Render.PdfDocument doc =
        await Render.PdfDocument.openFile(_fileEncrypted.value.path);
    var page = await doc.getPage(1);
    var imgPDF = await page.render();
    var img = await imgPDF.createImageDetached();
    var imgBytes = await img.toByteData(format: ImageByteFormat.png);
    var libImage = imglib.decodeImage(imgBytes.buffer
        .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
    MemoryImage memImg = new MemoryImage(imglib.encodeJpg(libImage));
    return memImg;
  }

  openFile() async {
    await OpenFile.open(_fileEncrypted.value.path);
  }

  Font getTypeFont(String id) {
    return _recipientVideo.firstWhere((element) => element.id == id).fontFamily;
  }

  Future<void> generatePdf(List<String> imagesPath) async {
    try {
      final box = GetStorage();
      var url = dotenv.env['URL'];
      var token = box.read("TOKEN");
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-type": 'multipart/form-data'
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/session/generate'),
      )..headers.addAll(headers);
      imagesPath.forEach((path) async {
        String name = Uuid().v4();
        request
          ..files.add(await http.MultipartFile.fromPath('images', path,
              filename: "$name.png", contentType: MediaType('image', 'png')));
      });

      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      var extracted = json.decode(respStr) as Map<String, dynamic>;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = new Session.fromJson(extracted['data']);
      final prefs = GetStorage();
      prefs.write("SOCKET_ROOM", extracted['data']['socketRoomName']);
      update();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
