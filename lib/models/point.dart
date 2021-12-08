import 'package:flutter/material.dart';

import 'package:notary/methods/hex_color.dart';
import 'package:notary/models/font_family.dart';

class Point {
  String id;
  Color color;
  bool isChecked;
  bool isSigned;
  String value;
  String type;
  double wPage;
  int page;
  Offset position;
  String ownerType;
  String ownerId;
  Font fontFamily;

  Point({
    this.id,
    this.color,
    this.isChecked,
    this.isSigned,
    this.value,
    this.type,
    this.wPage,
    this.page,
    this.position,
    this.ownerType,
    this.ownerId,
    this.fontFamily,
  });

  Point.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        type = json['type'],
        wPage = json['wPage'].toDouble(),
        page = json['page'],
        position = new Offset(json['x'].toDouble(), json['y'].toDouble()),
        ownerType = json['ownerType'],
        ownerId = json['ownerId'],
        isChecked = false,
        isSigned = json['isSigned'],
        color = HexColor.fromHex(json['color']),
        fontFamily = json['fontFamily'] == null ||
                json['fontFamily'].runtimeType == String
            ? null
            : Font.fromJson(json['fontFamily']);

  Map<String, dynamic> toJson() => {
        'color': color.toHex(),
        'value': value,
        'type': type,
        'wPage': wPage,
        'page': page,
        'x': position.dx,
        'y': position.dy,
        'ownerType': ownerType,
        'ownerId': ownerId,
      };

  @override
  String toString() {
    return 'Point{id: $id, color: $color, isChecked: $isChecked, isSigned: $isSigned, value: $value, type: $type, wPage: $wPage, page: $page, position: $position, ownerType: $ownerType, ownerId: $ownerId, fontFamily: $fontFamily}';
  }
}
