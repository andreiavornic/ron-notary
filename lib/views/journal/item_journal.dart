import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/models/journal.dart';

import 'info_journal.dart';
import 'journal_detail.dart';

class ItemJournal extends StatelessWidget {
  final Journal eJournal;

  ItemJournal({this.eJournal});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.to(() => JournalDetail(eJournal.id)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.zero,
        ),
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).accentColor.withOpacity(0.02),
        ),
      ),
      child: InfoJournal(eJournal: eJournal, icon: true),
    );
  }
}
