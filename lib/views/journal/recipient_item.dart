import 'package:flutter/material.dart';
import 'package:notary/models/recipient.dart';

import 'item_data.dart';

class RecipientItem extends StatelessWidget {
  final Recipient recipient;

  RecipientItem(this.recipient);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ItemData(
            '${recipient.type}:',
            recipient.firstName,
            false,
          ),
          ItemData(
            'Address:',
            "recipient.addressStreet1",
            false,
          ),
          ItemData(
            'KBA:',
            "recipient.addressStreet1",
            false,
          ),
          ItemData(
            'Identity Status:',
            "recipient.addressStreet1",
            false,
          ),
        ],
      ),
    );
  }
}