import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/services/session.dart';
import 'package:notary/services/type_notarization.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:pdf_render/pdf_render.dart' as Render;
import 'package:image/image.dart' as imglib;

class SessionController extends GetxController {
  final _session = Rx<Session>();
  final _box = GetStorage();
  final Rx<File> _fileEncrypted = Rx<File>(null);
  final Rx<String> _journalId = Rx<String>(null);
  RxList<TypeNotarization> _notarizations = RxList<TypeNotarization>();
  SessionService _sessionService = new SessionService();
  TypeNotarizationService _typeNotarizationService =
      new TypeNotarizationService();

  Rx<Session> get session => _session;

  RxList<TypeNotarization> get notarizations => _notarizations;

  @override
  void onInit() {
    super.onInit();
    getSession();
  }

  getSession() async {
    try {
      Response response = await _sessionService.getSession();
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = new Session.fromJson(extracted['data']);
      update();
    } catch (err) {
      _session.value = null;
      update();
      print(err);
      // throw err;
    }
  }

  Future<void> createSession(PlatformFile file) async {
    try {
      File fetchedFile = new File(file.path);
      Response response = await _sessionService.createSession(fetchedFile);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = new Session.fromJson(extracted['data']);
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateSession(
      String typeNotarization, String documentTitle) async {
    try {
      Response response =
          await _sessionService.updateSession(typeNotarization, documentTitle);
      var extracted = response.body;
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

  Future<void> deleteSession() async {
    try {
      Response response = await _sessionService.deleteSession();
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value = null;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getTypeNotarization() async {
    try {
      Response response = await _typeNotarizationService.getNotarization();
      var extracted = response.body;
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
      Response response = await _sessionService.changeStatus(status);
      var extracted = response.body;

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
      Response response = await _sessionService.changeStatus(status);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _session.value.state = status;
      _session.value.twilioRoomName = extracted['data']['twilioRoomName'];
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
      Response response = await _sessionService.changeStatus(status);
      var extracted = response.body;

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

  Future<void> encryptFile() async {
    try {
      await removeToken();
      String status = "FINISHED";
      Response response = await _sessionService.changeStatus(status);
      var extracted = jsonDecode(response.body);
      if (!extracted['success']) {
        throw extracted['message'];
      }
      // _session.value = null;
      _journalId.value = extracted['data'];
      await removeToken();
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> downloadFile() async {
    try {
      Response response = await _sessionService.downloadFile(_journalId.value);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      String dirLoc = await findLocalPath;
      String filePath = '$dirLoc/${_session.value.sessionFilePath}';

      File file = new File(filePath);
      var buffer = extracted['data']['data'] as List<dynamic>;
      await file.writeAsBytes(buffer.cast<int>());
      _fileEncrypted.value = file;
      update();
      await openFile();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  shareFile() async {
    await Share.shareFiles(
      [_fileEncrypted.value.path],
      subject: _session.value.sessionFileName,
    );
  }

  get fileEncrypted => _fileEncrypted;

  Future<void> saveToken(String token) async {
    await _box.write('TWILIO_TOKEN', token);
  }

  Future<void> removeToken() async {
    await _box.remove('TWILIO_TOKEN');
  }

  Future<String> get findLocalPath async {
    String directory;
    if (Platform.isAndroid) {
      directory = '/storage/emulated/0/Download';
    } else {
      directory = (await getApplicationDocumentsDirectory()).path;
    }
    return directory;
  }

  Future<MemoryImage> formatImage() async {
    print("formatImage() => Executed!");
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
}
