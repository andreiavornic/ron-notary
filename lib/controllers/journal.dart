import 'dart:io';

import 'package:get/get.dart';
import 'package:notary/methods/find_local.dart';
import 'package:notary/models/journal.dart';
import 'package:notary/services/dio_service.dart';

import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class JournalController extends GetxController {
  RxList<Journal> _journals = RxList<Journal>([]);
  RxList<Journal> _journalSorted = RxList<Journal>([]);

  RxList<Journal> get journals => _journals;

  RxList<Journal> get journalSorted => _journalSorted;

  getjournals() async {
    try {
      dio.Response resDio = await makeRequest('journal', "GET", null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach((json) {
        _journals.add(new Journal.fromJson(json));
      });
      _journalSorted = _journals;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<Map<String, dynamic>> getJournalById(String id) async {
    try {
      dio.Response resDio = await makeRequest('journal/$id', "GET", null);
      var extracted = resDio.data;
      if (extracted == null) {
        throw "Something was wrong please try again";
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      return extracted['data'];
    } catch (err) {
      throw err;
    }
  }

  Future<void> getJournalDocument(String encryptedPDF) async {
    try {
      dio.Response resDio =
          await makeRequest('journal', 'POST', {"encryptedPDF": encryptedPDF});
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      String dirLoc = await findLocalPath;
      String filePath = '$dirLoc/$encryptedPDF.pdf';

      File file = new File(filePath);
      var buffer = extracted['data']['Body']['data'] as List<dynamic>;
      await file.writeAsBytes(buffer.cast<int>());
      await OpenFile.open(file.path);
    } catch (err) {
      throw err;
    }
  }

  Future<void> getJournalStep(String id) async {
    try {
      dio.Response resDio = await makeRequest(
        'journal/steps/$id',
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
      String filePath = '$dirLoc/steps.pdf';

      File file = new File(filePath);
      var buffer = extracted['data']['Body']['data'] as List<dynamic>;
      await file.writeAsBytes(buffer.cast<int>());
      await OpenFile.open(file.path);
      // return new Journal.fromJson(extracted['data']);
    } catch (err) {
      throw err;
    }
  }

  Future<void> getJournalMedia(Journal journal) async {
    try {
      dio.Response resDio = await makeRequest(
        'journal/media/${journal.id}',
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
      await startDownload(extracted['data'], journal);
    } catch (err) {
      throw err;
    }
  }

  Future<void> startDownload(String _urlMedia, Journal journal) async {
    print("startDownload() =>  Executed!");
    final request = http.Request('GET', Uri.parse(_urlMedia));
    final http.StreamedResponse response = await http.Client().send(request);
    List<int> bytes = [];
    final path = await findLocalPath;
    File videoFile = new File('$path/${journal.session.sessionToken}.mp4');
    videoFile = new File('$path/${journal.session.sessionToken}.mp4');

    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
      },
      onDone: () async {
        await videoFile.writeAsBytes(bytes);
        await OpenFile.open(videoFile.path);
      },
      onError: (e) {
        throw e;
      },
      cancelOnError: true,
    );
  }

  sortJournals(String name) {
    if (name.isEmpty) {
      _journalSorted = _journals;
    } else {
      _journalSorted = RxList<Journal>(_journals
          .where((element) =>
              element.name.toLowerCase().contains(name.toLowerCase()))
          .toList());
    }
    update();
  }
}
