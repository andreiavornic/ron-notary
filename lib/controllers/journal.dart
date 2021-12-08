import 'package:get/get.dart';
import 'package:notary/models/journal.dart';
import 'package:notary/services/journal.dart';

class JournalController extends GetxController {
  JournalService _journalService = new JournalService();
  RxList<Journal> _journals = RxList<Journal>([]);
  RxList<Journal> _journalSorted = RxList<Journal>([]);

  RxList<Journal> get journals => _journals;

  RxList<Journal> get journalSorted => _journalSorted;

  @override
  void onInit() {
    super.onInit();
    getjournals();
  }

  getjournals() async {
    try {
      Response response = await _journalService.getJournals();
      var extracted = response.body;
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

  Future<Journal> getJournalById(String id) async {
    try {
      Response response = await _journalService.getJournalById(id);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      return new Journal.fromJson(extracted['data']);
    } catch (err) {
      throw err;
    }
  }

  sortJournals(String name) {
    if (name.isEmpty) {
      _journalSorted = _journals;
    } else {
      _journalSorted = RxList<Journal>(_journals
          .where((element) => element.name.toLowerCase().contains(name.toLowerCase()))
          .toList());
    }
    update();
  }
}
