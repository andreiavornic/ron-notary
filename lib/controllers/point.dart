import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/point.dart';
import 'package:notary/services/point.dart';

class PointController extends GetxController {
  PointService _pointService = new PointService();
  RxList<Point> _points = RxList<Point>([]);

  RxList<Point> get points => _points;

  @override
  void onInit() {
    super.onInit();
    getPoints();
  }

  getPoints() async {
    try {
      Response response = await _pointService.getPoints();
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach(
        (json) => addPoint(
          new Point.fromJson(json),
        ),
      );
    } catch (err) {
      throw err;
    }
  }

  addPoints() async {
    try {
      Response response = await _pointService.addPoints(_points);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      RxList<Point> pointsResult = RxList<Point>([]);
      extracted['data'].forEach(
        (json) => pointsResult.add(
          new Point.fromJson(json),
        ),
      );
      _points = pointsResult;
      update();
    } catch (err) {
      throw err;
    }
  }

  addSign() async {
    try {
      Response response = await _pointService.updatePoints("ALL");
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach(
        (json) => updateSignPoint(json),
      );
    } catch (err) {
      showError(err);
    }
  }

  addStamp() async {
    try {
      Response response = await _pointService.updatePoints("STAMP");
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach(
            (json) => updateSignPoint(json),
      );
    } catch (err) {
      showError(err);
    }
  }

  updateSignPoint(Map<String, dynamic> json) {
    int index = _points.indexWhere((element) => element.id == json['id']);
    _points[index].isSigned = json['isSigned'];
    update();
  }

  addPoint(Point point) {
    _points.add(point);
    update();
  }

  updatePositionPoint(Point point, Offset position) {
    _points.firstWhere((element) => element == point).position = position;
    update();
  }

  activatePoint(int index) {
    _points.forEach((element) => element.isChecked = false);
    _points[index].isChecked = true;
    update();
  }

  cancelEdit() {
    _points.forEach((element) => element.isChecked = false);
    update();
  }

  editPoint(String txt) {
    _points.firstWhere((element) => element.isChecked).value = txt;
    _points.forEach((element) => element.isChecked = false);
    update();
  }

  deletePoint() {
    Point pointForDelete = _points.firstWhere((element) => element.isChecked);
    _points.remove(pointForDelete);
    update();
  }
}
