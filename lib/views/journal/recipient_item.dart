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
            recipient.address,
            false,
          ),
          ItemData(
            'KBA:',
            recipient.kba != null &&  recipient.kba ? "Passed" : "Failed",
            false,
          ),
          ItemData(
            'Identity Status:',
            recipient.idenfy != null &&  recipient.idenfy  ? "Passed" : "Failed",
            false,
          ),
        ],
      ),
    );
  }
}