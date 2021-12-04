import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/models/point.dart';

class GetStamp extends StatelessWidget {
  final Point point;
  final UserController _userController = Get.put(UserController());

  GetStamp(this.point);

  @override
  Widget build(BuildContext context) {
    int stamp = 1;
    return point.isSigned
        ? Container(
            width: stamp > 2 ? _calcThirdStampWidth() : _calcFirstStampWidth(),
            height:
                stamp > 2 ? _calcThirdStampWidth() : _calcFirstStampHeight(),
            child: Image.memory(base64Decode(
              _userController.stamp.value,
            )))
        : stamp > 2
            ? Container(
                width: _calcThirdStampWidth(),
                height: _calcThirdStampWidth(),
                decoration: BoxDecoration(
                  color: point.isChecked
                      ? Color(0xFFFFC700).withOpacity(0.6)
                      : Color(0xFFFFC700).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color(0xFFFFC700),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/61.svg',
                    width: 24,
                    color: Color(0xFFFFC700),
                  ),
                ),
              )
            : Container(
                width: _calcFirstStampWidth(),
                height: _calcFirstStampHeight(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: point.isChecked
                      ? Color(0xFFFFC700).withOpacity(0.6)
                      : Color(0xFFFFC700).withOpacity(0.15),
                  border: Border.all(
                    color: Color(0xFFFFC700),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/61.svg',
                    width: 24,
                    color: Color(0xFFFFC700),
                  ),
                ),
              );
  }

  double _calcFirstStampWidth() {
    return (point.wPage / 3.30);
  }

  double _calcThirdStampWidth() {
    return (point.wPage / 4.13);
  }

  double _calcFirstStampHeight() {
    return (_calcFirstStampWidth() / 2.5);
  }
}
