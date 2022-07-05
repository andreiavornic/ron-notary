import 'package:flutter/cupertino.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/utils/navigate.dart';

import 'button_primary.dart';

class SelectTypeNotarization extends StatefulWidget {
  final List<TypeNotarization> sortedTypeDocuments;
  final Function selectItem;
  final TypeNotarization selectedType;

  SelectTypeNotarization(
    this.sortedTypeDocuments,
    this.selectItem,
    this.selectedType,
  );

  @override
  _SelectTypeNotarizationState createState() => _SelectTypeNotarizationState();
}

class _SelectTypeNotarizationState extends State<SelectTypeNotarization> {
  int _itemSelected = 0;

  initState() {
    if (widget.selectedType != null) {
      _itemSelected = widget.sortedTypeDocuments.indexWhere(
        (element) => element.id == widget.selectedType.id,
      );
    }
    super.initState();
  }

  void _selectNotarization() {
    Navigator.of(context).pop();
    return widget.selectItem(widget.sortedTypeDocuments[_itemSelected]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: StateM(context).height() / 3,
      child: Column(
        children: [
          Text(
            'Type of Notarization ',
            style: TextStyle(
              color: Color(0xFFF161617),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: reSize(context, 15)),
          Text('Choose type of notarization'),
          SizedBox(height: reSize(context, 20)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoPicker(
                itemExtent: 52,
                scrollController: FixedExtentScrollController(
                  initialItem: _itemSelected,
                ),
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFCDCDCD),
                    ),
                  ),
                ),
                children: widget.sortedTypeDocuments.map((item) {
                  return Container(
                    height: reSize(context, 52),
                    child: Center(
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF494949),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onSelectedItemChanged: (int index) {
                  _itemSelected = index;
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(height: reSize(context, 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonPrimary(
              text: 'Select',
              callback: _selectNotarization,
            ),
          ),
          SizedBox(height: reSize(context, 40)),
        ],
      ),
    );
  }
}
