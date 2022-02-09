import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/models/point.dart';
import 'package:notary/views/tags/tag_touch_part.dart';

class DocumentTagSession extends StatefulWidget {
  @override
  _DocumentTagSessionState createState() => _DocumentTagSessionState();
}

class _DocumentTagSessionState extends State<DocumentTagSession> {
  Matrix4 _matrix;
  ValueNotifier<Matrix4> notifier;
  TransformationController _transformationController;
  double wPage;

  SessionController _sessionController = Get.put(SessionController());

  List<Image> _images;

  @override
  void initState() {
    _matrix = Matrix4.identity();
    notifier = ValueNotifier(_matrix);
    _transformationController = TransformationController();

    initImages();
    super.initState();
  }

  initImages() {
    _images = List<String>.from(_sessionController.session.value.images)
        .map((image) => new Image.memory(base64Decode(image)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(builder: (_controller) {
      return Container(
        child: Center(
          child: Stack(
            children: [
              MatrixGestureDetector(
                shouldRotate: false,
                onMatrixUpdate: (m, tm, sm, rm) {
                  _matrix =
                      MatrixGestureDetector.compose(_matrix, tm, sm, null);
                  notifier.value = _matrix;
                  setState(() {});
                },
                child: AnimatedBuilder(
                  animation: notifier,
                  builder: (ctx, _) {
                    return Transform(
                      transform: notifier.value,
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,
                        transformationController: _transformationController,
                        child: SingleChildScrollView(
                          physics: _controller.points
                                  .any((element) => element.isChecked)
                              ? NeverScrollableScrollPhysics()
                              : ScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              for (int i = 0; i < _images.length; i++)
                                _getImageAndPoints(
                                  _controller.points,
                                  _images[i],
                                  i,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _getImageAndPoints(
    List<Point> _points,
    Image image,
    int index,
  ) {
    List<Point> _sortedPoints =
        _points.where((element) => element.page == index).toList();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                wPage = constraints.maxWidth;
                return image;
              },
            ),
            Container(
              height: 1,
              color: Color(0xFF000000).withOpacity(0.3),
            )
          ],
        ),
        for (var point in _sortedPoints)
          Positioned(
            left: point.position.dx,
            top: point.position.dy,
            child: TouchTagPart(
              point: point,
            ),
          ),
      ],
    );
  }
}
