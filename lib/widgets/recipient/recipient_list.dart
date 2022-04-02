import 'package:flutter/material.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/widgets/recipient/recipient_tag.dart';
import 'package:provider/provider.dart';

class RecipientList extends StatefulWidget {
  final Function resetType;

  RecipientList(this.resetType);

  @override
  _RecipientListState createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipientController>(
      builder: (context, _recipientController, _) {
        return Container(
          height: 74,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                child: RecipientTag(
                  recipient: _recipientController.recipientsForTag[index],
                  resetType: widget.resetType,
                ),
              );
            },
            itemCount: _recipientController.recipientsForTag.length,
          ),
        );
      },
    );
  }
}
