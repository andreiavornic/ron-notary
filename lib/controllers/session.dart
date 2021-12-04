import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/services/session.dart';
import 'package:notary/services/type_notarization.dart';

class SessionController extends GetxController {
  final _session = Rx<Session>();
  final _box = GetStorage();
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
      _session.value.sessionFileName = documentTitle;
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
      print(extracted);
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
      String status = "FINISHED";
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

  Future<void> saveToken(String token) async {
    await _box.write('TWILIO_TOKEN', token);
  }

  Future<void> removeToken() async {
    await _box.remove('TWILIO_TOKEN');
  }
}
