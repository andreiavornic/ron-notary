import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';

modalContainer(Widget widget, BuildContext context) {
  ScrollController _scrollController = new ScrollController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: NotificationListener(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              if (_scrollController.position.pixels == 0) {
                StateM(context).navBack();
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: Wrap(
              children: [
                Container(
                  width: StateM(context).width(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: reSize(context, 50),
                        height: reSize(context, 4),
                        decoration: BoxDecoration(
                            color: Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(height: reSize(context, 20)),
                    ],
                  ),
                ),
                widget
              ],
            ),
          ),
        ),
      );
    },
  );
}

modalContainerSimple(Widget widget, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: reSize(context, 50),
                    height: reSize(context, 4),
                    decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(height: reSize(context, 20)),
                ],
              ),
              widget
            ],
          ),
        ),
      );
    },
  );
}
