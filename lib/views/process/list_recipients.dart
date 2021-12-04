import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/views/process/recipient_status.dart';

class ListRecipients extends StatelessWidget {
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _recipientController.recipients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 24),
          child: RecipientStatus(_recipientController.recipients[index]),
        );
      },
    );
  }
}
