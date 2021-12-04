import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/widgets/recipient/recipient_tag.dart';

class RecipientList extends StatefulWidget {
  final Function resetType;


  RecipientList(this.resetType);

  @override
  _RecipientListState createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipientController>(
      init: RecipientController(),
      builder: (_recipientController) {
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
