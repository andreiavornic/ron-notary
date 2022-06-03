import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notary/enum/stage_enum.dart';
import 'package:notary/methods/find_local.dart';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

class SessionController extends ChangeNotifier {
  Session _session;
  File _fileEncrypted;

  List<Recipient> _recipients = [];
  List<Recipient> _recipientVideo = [];
  List<Point> _points = [];
  List<TypeNotarization> _notarizations = [];

  String _sessionFileName;
  String _sessionFilePath;

  String get sessionFileName => _sessionFileName;

  Session get session => _session;

  List<TypeNotarization> get notarizations => _notarizations;

  List<Recipient> get recipientVideo => _recipientVideo;

  List<Recipient> get recipients => _recipients;

  List<Point> get points => _points;

  getSession() async {
    try {
      dio.Response resDio = await makeRequest('session', 'GET', null);
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session = new Session.fromJson(extracted['data']['session']);
      _recipients = [];
      _recipientVideo = [];
      _points = [];
      _getUserData(extracted['data']['user']);

      extracted['data']['session']['recipients'].forEach((json) {
        _recipients.add(new Recipient.fromJson(json));
        _recipientVideo.add(new Recipient.fromJson(json));
      });

      extracted['data']['session']['points'].forEach((json) {
        _points.add(new Point.fromJson(json));
      });

      _sessionFileName = extracted['data']['session']['sessionFileName'];
      _sessionFilePath = extracted['data']['session']['sessionFilePath'];
      _fileEncrypted = null;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("SESSION_ID", extracted['data']['session']['id']);

      if (_session.twilioRoomName != null) {
        prefs.setString("TWILIO_ROOM", _session.twilioRoomName);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      _session = null;
      notifyListeners();
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

  Future<void> createSession(File file) async {
    try {
      String originalname = basename(file.path);
      var url = dotenv.env['URL'];
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("TOKEN");
      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-type": 'multipart/form-data',
        "Platform": Platform.operatingSystem
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/session'),
      )..headers.addAll(headers);

      request
        ..files.add(await http.MultipartFile.fromPath('file', file.path,
            filename: originalname,
            contentType: MediaType('application', 'pdf')));

      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      var extracted = json.decode(respStr) as Map<String, dynamic>;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session = new Session.fromJson(extracted['data']);
      notifyListeners();
    } catch (err) {
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

      _session.typeNotarization =
          new TypeNotarization.fromJson(extracted['data']['typeNotarization']);
      _session.sessionFileName = extracted['data']['sessionFileName'];
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateStage(String stage) async {
    try {
      dio.Response resDio = await makeRequest(
        'session/${_session.id}',
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
    _session.stage =
        Stage.values.firstWhere((element) => element.name == stage);
    notifyListeners();
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
      _session = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("SOCKET_ROOM");
      notifyListeners();
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
      _notarizations = [];
      extracted['data'].forEach((json) {
        _notarizations.add(new TypeNotarization.fromJson(json));
      });
      notifyListeners();
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
      _session.state = status;
      notifyListeners();
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
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.state = status;

      saveToken(extracted['data']['token']);
      notifyListeners();
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
      _session.state = status;
      await removeToken();
      notifyListeners();
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
      _session = null;
      await removeToken();
      notifyListeners();
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
      await removeToken();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> downloadFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.getString("SESSION_ID");
      dio.Response resDio = await makeRequest(
        'session/$id',
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
      String filePath = '$dirLoc/$_sessionFilePath';

      File file = new File(filePath);
      var buffer = extracted['data']['data'] as List<dynamic>;
      await file.writeAsBytes(buffer.cast<int>());
      _fileEncrypted = file;
      _session = null;
      notifyListeners();
      prefs.remove("SESSION_ID");
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
    notifyListeners();
  }

  updateRecipients(data) {
    // getSession();
    int index =
        _recipients.indexWhere((recipient) => recipient.id == data['id']);
    if (index >= 0) {
      _recipients[index].states =
          List<String>.from(data['states']).map((state) => state).toList();
      _recipients[index].firstName = data['firstName'];
      _recipients[index].lastName = data['lastName'];
    }
    notifyListeners();
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
    notifyListeners();
  }

  updatePoints(data) {
    data.forEach((element) {
      int index = _points.indexWhere((point) => point.id == element['id']);
      if (index >= 0) {
        _points[index].isSigned = element['isSigned'];
      }
    });
    notifyListeners();
  }

  updateOnePoint(data) {
    int index = _points.indexWhere((point) => point.id == data['id']);
    if (index >= 0) {
      _points[index].isSigned = data['isSigned'];
    }
    notifyListeners();
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

  signPoint(String id) async {
    try {
      print(id);
      dio.Response resDio = await makeRequest('point/$id', "POST", {});

      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  shareFile() async {
    await Share.shareFiles(
      [_fileEncrypted.path],
      subject: _sessionFileName,
    );
  }

  get fileEncrypted => _fileEncrypted;

  void saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('TWILIO_TOKEN', token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('TWILIO_TOKEN');
  }

  Future<MemoryImage> formatImage() async {
    Render.PdfDocument doc =
        await Render.PdfDocument.openFile(_fileEncrypted.path);
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
    await OpenFile.open(_fileEncrypted.path);
  }

  String getTypeFont(String id) {
    int index = _recipientVideo.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    return _recipientVideo[index].fontFamily.fontFamily;
  }

  Future<void> generatePdf(List<String> imagesPath) async {
    try {
      _session = null;
      _recipients = [];
      _recipientVideo = [];
      _points = [];
      final prefs = await SharedPreferences.getInstance();
      var url = dotenv.env['URL'];
      var token = prefs.getString("TOKEN");

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-type": 'multipart/form-data',
        "Platform": Platform.operatingSystem
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/session/generate'),
      )..headers.addAll(headers);

      imagesPath.forEach((path) async {
        File newFile = File(path);
        String name = Uuid().v4();
        var stream = new http.ByteStream(newFile.openRead());
        var length = await newFile.length();
        var multipartFileSign = new http.MultipartFile(
          'images',
          stream,
          length,
          filename: "$name.png",
        );

        request.files.add(multipartFileSign);
      });

      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      var extracted = json.decode(respStr) as Map<String, dynamic>;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session = new Session.fromJson(extracted['data']);
      await getSession();
      notifyListeners();
    } on SocketException catch (err) {
      throw err.message;
    } catch (err) {
      throw err;
    }
  }
}
