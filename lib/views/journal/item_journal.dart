import 'package:flutter/material.dart';

import 'package:notary/models/journal.dart';
import 'package:notary/utils/navigate.dart';

import 'info_journal.dart';
import 'journal_detail.dart';

class ItemJournal extends StatelessWidget {
  final Journal eJournal;

  ItemJournal({this.eJournal});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => StateM(context).navTo(JournalDetail(eJournal.id)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.zero,
        ),
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.secondary.withOpacity(0.02),
        ),
      ),
      child: InfoJournal(eJournal: eJournal, icon: true),
    );
  }
}
