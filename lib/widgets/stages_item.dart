import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/enum/stage_enum.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';

class StageItem extends StatefulWidget {
  final String title;
  final String description;
  final int item;
  final bool last;
  final Stage needStage;

  StageItem({
    @required this.needStage,
    this.title,
    this.description,
    this.item,
    this.last,
  });

  @override
  _StageItemState createState() => _StageItemState();
}

class _StageItemState extends State<StageItem> {
  Stage _stage;
  SessionController _sessionController = Get.put(SessionController());

  _navigateToPage(Stage _stage) async {
    switch (widget.item) {
      case (1):
        await _updateSessionStage(_stage, "SELECT_DOCUMENT");
        break;
      case (2):
        await _updateSessionStage(_stage, "DOCUMENT_SETTING");
        break;
      case (3):
        await _updateSessionStage(_stage, "ADD_PARTICIPANT");
        break;
      case (4):
        await _updateSessionStage(_stage, "TAGS");
        break;
      case (5):
        await _updateSessionStage(_stage, "INVITE");
        break;
    }
    return;
  }

  _updateSessionStage(Stage stage, String stageSt) async {
    try {
      await _sessionController.updateStage(stageSt);
      for (int i = widget.item ; i <= stage.index + 1; i++) {
        Get.back();
      }
    } catch (err) {
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(builder: (_controller) {
      _stage = _controller.session.value.stage;
      return InkWell(
        overlayColor:
            MaterialStateProperty.all(Color(0xFF000000).withOpacity(0)),
        highlightColor: Color(0xFF000000).withOpacity(0),
        onTap: _stage == null
            ? null
            : _stage.index + 1 == widget.item
                ? () => Get.back()
                : _stage.index + 1 > widget.item
                    ? () => _navigateToPage(_stage)
                    : null,
        child: Container(
          height: reSize(80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: reSize(23),
                child: Column(
                  children: [
                    Container(
                      width: reSize(23),
                      height: reSize(23),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Container(
                          width: reSize(15),
                          height: reSize(15),
                          decoration: BoxDecoration(
                            color: _stage == null
                                ? Color(0xFFFFFFFF)
                                : _stage.index > widget.item ||
                                        _stage.index == widget.item
                                    ? Theme.of(context).primaryColor
                                    : Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 1,
                              color: _stage == null
                                  ? Color(0xFFCDCDCD)
                                  : _stage.index > widget.item
                                      ? Theme.of(context).primaryColor
                                      : _stage == widget.needStage
                                          ? Theme.of(context).primaryColor
                                          : Color(0xFFCDCDCD),
                            ),
                          ),
                          child: _stage == null
                              ? Container()
                              : _stage.index > widget.item ||
                                      _stage.index == widget.item
                                  ? Center(
                                      child: Container(
                                        child: Icon(
                                          Icons.check,
                                          size: 9,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Container(
                                        width: reSize(7),
                                        height: reSize(7),
                                        decoration: BoxDecoration(
                                          color: _stage == widget.needStage
                                              ? Theme.of(context).primaryColor
                                              : Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    if (widget.last == null)
                      Container(
                        width: reSize(1),
                        height: reSize(56),
                        color: Color(0XFFCDCDCD),
                      ),
                  ],
                ),
              ),
              SizedBox(width: reSize(10)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: reSize(4)),
                    Text(
                      '${widget.item}. ${widget.title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: reSize(3)),
                    Text(
                      '${widget.description}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFADAEAF),
                      ),
                    ),
                    SizedBox(height: reSize(3)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
