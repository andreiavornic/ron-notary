import 'package:flutter/material.dart';
import 'package:notary/models/point.dart';
import 'package:notary/views/tags/tag_touch_part.dart';

class TagTouch extends StatefulWidget {
  final Function onDrag;
  final Function onTap;
  final Point point;

  TagTouch({
    @required this.onDrag,
    @required this.onTap,
    this.point,
  });

  @override
  _TagTouchState createState() => _TagTouchState();
}

class _TagTouchState extends State<TagTouch> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onPanStart: _startDragging,
      onPanUpdate: _drag,
      onPanCancel: _cancelDragging,
      onPanEnd: (_) => _cancelDragging(),
      child: TouchTagPart(
        point: widget.point,
        text: widget.point.value,
        imgWidth: widget.point.wPage,
      ),
    );
  }

  void _startDragging(DragStartDetails data) {
    setState(() {
      dragging = true;
    });
  }

  void _cancelDragging() {
    setState(() {
      dragging = false;
    });
  }

  void _drag(DragUpdateDetails data) {
    if (!dragging) {
      return;
    }
    widget.onDrag(widget.point, data);
  }
}
