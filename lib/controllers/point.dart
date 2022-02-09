import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notary/models/point.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

class PointController extends GetxController {
  RxList<Point> _points = RxList<Point>([]);

  RxList<Point> get points => _points;

  @override
  void onInit() {
    // getPoints();
    super.onInit();
  }

  reset() {
    _points.clear();
    update();
  }

  getPoints() async {
    try {
      dio.Response resDio = await makeRequest('point', "GET", null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _points.clear();
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
      List<Map<String, dynamic>> data = [];
      points.forEach((element) {
        data.add(element.toJson());
      });
      dio.Response resDio = await makeRequest('point', 'POST', data);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }

      print("extracted $extracted");
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
      print(err);
      throw err;
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

  updatePoints(data) {
    data.forEach((element) {
      int index = _points.indexWhere((point) => point.id == element['id']);
      if (index >= 0) {
        _points[index].isSigned = element['isSigned'];
      }
    });
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
