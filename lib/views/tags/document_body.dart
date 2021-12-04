import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/point.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/recipient.dart';

import 'btn_tags.dart';
import 'navigator_tags.dart';

class DocumentBody extends StatefulWidget {
  final Widget documentTag;
  final Recipient activeRecipient;
  final String typeSignature;
  final Function editPoint;
  final Function deletePoint;
  final Function cancelEdit;
  final Function changeTypeSignature;

  DocumentBody({
    this.documentTag,
    this.activeRecipient,
    this.typeSignature,
    this.editPoint,
    this.deletePoint,
    this.cancelEdit,
    this.changeTypeSignature,
  });

  @override
  _DocumentBodyState createState() => _DocumentBodyState();
}

class _DocumentBodyState extends State<DocumentBody> {
  RecipientController _recipientController = Get.put(RecipientController());
  Color _baseColor;
  double widthConstrain;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<PointController>(
          init: PointController(),
          builder: (_pointController) {
            _baseColor = _recipientController.recipientsForTag
                .firstWhere((element) => element.isActive)
                .color;
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFEDEDED),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: LayoutBuilder(
                            builder: (builder, constrain) {
                              //  widthConstrain = constrain.maxWidth;
                              return widget.documentTag;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: reSize(59),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFBFD).withOpacity(0.9),
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFEDEDED),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xFFEDEDED),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Color(0xFFEDEDED),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: Color(0xFFEDEDED),
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: _pointController.points
                            .any((element) => element.isChecked)
                        ? Container(
                            child: Row(
                              children: [
                                widget.typeSignature == "TEXTBOX"
                                    ? BtnTags(
                                        baseColor: _baseColor,
                                        icon: 'assets/images/60.svg',
                                        callback: widget.editPoint,
                                        text: 'Edit',
                                        active: false,
                                      )
                                    : Container(),
                                widget.typeSignature == "TEXTBOX"
                                    ? SizedBox(width: reSize(20))
                                    : SizedBox(),
                                BtnTags(
                                  baseColor: _baseColor,
                                  icon: 'assets/images/34.svg',
                                  callback: widget.deletePoint,
                                  text: 'Delete',
                                  active: false,
                                ),
                                SizedBox(width: reSize(20)),
                                BtnTags(
                                  baseColor: _baseColor,
                                  icon: 'assets/images/35.svg',
                                  callback: widget.cancelEdit,
                                  text: 'Cancel',
                                  active: false,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: NavigatorTags(
                              baseColor: _baseColor,
                              selectedRecipient: widget.activeRecipient,
                              typeSignature: widget.typeSignature,
                              changeTypeSignature: widget.changeTypeSignature,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
