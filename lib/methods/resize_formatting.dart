

import 'package:flutter/cupertino.dart';
import 'package:notary/utils/navigate.dart';

double reSize(BuildContext context, int currentValue) {
  double ratio = StateM(context).devicePixelRatio() / 150;
  if (ratio < 3.0) {
    return currentValue / 1.2;
  }
  return currentValue / 1;
}
