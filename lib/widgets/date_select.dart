import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateSelect extends StatefulWidget {
  final Function callback;
  final List<Widget> items;
  final int initialItem;

  DateSelect({this.callback, this.items, this.initialItem});

  @override
  _DateSelectState createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      looping: true,
      backgroundColor: Colors.white,
      selectionOverlay: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFFCDCDCD)),
              bottom: BorderSide(width: 1.0, color: Color(0xFFCDCDCD)),
            ),
          ),
        ),
      ),
      itemExtent: 40,
      scrollController: FixedExtentScrollController(
        initialItem: widget.initialItem != null ? widget.initialItem : 0,
      ),
      children: widget.items,
      onSelectedItemChanged: (int value) {
        return widget.callback(value);
      },
    );
  }
}
