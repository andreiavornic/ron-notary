import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/point.dart';
import 'package:notary/models/recipient.dart';

import 'btn_tags.dart';

class NavigatorTags extends StatefulWidget {
  final Color baseColor;
  final Recipient selectedRecipient;
  final String typeSignature;
  final Function changeTypeSignature;

  NavigatorTags({
    @required this.baseColor,
    @required this.selectedRecipient,
    @required this.typeSignature,
    @required this.changeTypeSignature,
  });

  @override
  _NavigatorTagsState createState() => _NavigatorTagsState();
}

class _NavigatorTagsState extends State<NavigatorTags> {
  @override
  void initState() {
    super.initState();
  }

  // _pointController.points.any((element) => element.type == "STAMP")

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PointController>(
      init: PointController(),
      builder: (_pointController) {
        return Row(
          children: [
            BtnTags(
              baseColor: widget.baseColor,
              icon: 'assets/images/60.svg',
              callback: () => widget.changeTypeSignature('SIGNATURE'),
              text: 'Signature',
              active: widget.typeSignature == 'SIGNATURE',
            ),
            widget.selectedRecipient != null &&
                    widget.selectedRecipient.type == 'NOTARY' &&
                    !_pointController.points
                        .any((element) => element.type == "STAMP")
                ? BtnTags(
                    baseColor: widget.baseColor,
                    icon: 'assets/images/61.svg',
                    callback: () => widget.changeTypeSignature("STAMP"),
                    text: 'Stamp',
                    active: widget.typeSignature == "STAMP",
                  )
                : Container(),
            widget.selectedRecipient != null &&
                    widget.selectedRecipient.type == 'NOTARY'
                ? BtnTags(
                    baseColor: widget.baseColor,
                    icon: 'assets/images/62.svg',
                    callback: () => widget.changeTypeSignature("DATE"),
                    text: 'Date',
                    active: widget.typeSignature == "DATE",
                  )
                : BtnTags(
                    baseColor: widget.baseColor,
                    icon: 'assets/images/64.svg',
                    callback: () => widget.changeTypeSignature("INITIAL"),
                    text: 'Initials',
                    active: widget.typeSignature == "INITIAL",
                  ),
            widget.selectedRecipient != null &&
                    widget.selectedRecipient.type == 'NOTARY'
                ? BtnTags(
                    baseColor: widget.baseColor,
                    icon: 'assets/images/63.svg',
                    callback: () => widget.changeTypeSignature("TEXTBOX"),
                    text: 'Textbox',
                    active: widget.typeSignature == "TEXTBOX",
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
