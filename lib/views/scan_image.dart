import 'dart:async';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/document-setting.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/detail_image.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

class ScanImage extends StatefulWidget {
  @override
  _ScanImageState createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  List<String> _imagePaths;
  String _imagePath;
  int _indexSelected;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    _imagePaths = [];
    getImage();
    super.initState();
  }

  Future<void> getImage() async {
    try {
      String imagePath = (await EdgeDetection.detectEdge);
      if (imagePath != null) {
        _imagePath = imagePath;
        _imagePaths.add(_imagePath);
        setState(() {});
      } else if (_imagePath == null || _imagePaths.length == 0) {
        Navigator.pop(context);
      }
    } on PlatformException catch (err) {
      showError(err, context);
    }
  }

  Future<void> _convertImageToPDF() async {
    _isLoading = true;
    setState(() {});
    try {
      int totalLength = 0;
      _imagePaths.forEach((element) {
        totalLength += new File(element).lengthSync();
      });
      if (totalLength > 1.45e+7) throw "Your document is bigger than 15 MB,\n please scan only documents";
      await Provider.of<SessionController>(context, listen: false)
          .generatePdf(_imagePaths);
      _isLoading = false;
      setState(() {});
      Navigator.pop(context);
      StateM(context).navTo(DocumentSetting());
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _deleteImg() {
    if (_indexSelected != null) {
      _imagePaths.removeAt(_indexSelected);
      setState(() {});
    }
    if (_imagePaths.length == 0) {
      Navigator.pop(context);
    }
  }

  _navToImg(int i) {
    _indexSelected = i;
    setState(() {});
    StateM(context).navTo(DetailImage(_imagePaths[i], _deleteImg));
  }

  ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      _isLoading,
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TitlePage(
                needNav: true,
                title: "Scanned Pages",
                description: "Please add all pages to continue"),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: <Widget>[
                  InkWell(
                    onTap: () => getImage(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/images/119.svg"),
                          SizedBox(height: 5),
                          Text(
                            "Photo",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  for (var i = 0; i < _imagePaths.length; i++)
                    InkWell(
                      onTap: () => _navToImg(i),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Color(0xFF999999).withOpacity(0.3),
                              width: 1,
                            )),
                        child: ColorFiltered(
                          colorFilter: greyscale,
                          child: Image.file(
                            File(_imagePaths[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Based on the order of your scans, we will then combine all of the pages into a single document.",
                    style: TextStyle(
                      color: Color(0xFF20303C),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "All pages of a document must be uploaded in order to ensure a successful notary session. ",
                    style: TextStyle(
                      color: Color(0xFF20303C),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonPrimary(
                          text: "Upload",
                          callback: _imagePaths.length == 0
                              ? null
                              : _convertImageToPDF,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
