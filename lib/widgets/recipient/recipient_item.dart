import 'package:flutter/material.dart';
import 'package:notary/models/recipient.dart';

class RecipientItem extends StatelessWidget {
  final Recipient recipient;

  RecipientItem(this.recipient);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: recipient.color,
            ),
            child: Center(
              child: Text(
                recipient.firstName[0] + recipient.lastName[0],
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                   "${recipient.firstName} ${recipient.lastName}",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  recipient.type[0].toUpperCase() +
                      recipient.type.substring(1).toLowerCase(),
                  style: TextStyle(
                    color: Color(0xFFADAEAF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
