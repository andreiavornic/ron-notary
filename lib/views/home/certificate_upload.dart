import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary_outline.dart';

import 'certificate_password.dart';

class CertificateUpload extends StatefulWidget {
  @override
  _CertificateUploadState createState() => _CertificateUploadState();
}

class _CertificateUploadState extends State<CertificateUpload> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/99.svg',
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(
          "To start using Ronary please upload\ndigital certificate",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        ButtonPrimaryOutline(
          width: 232,
          text: "Upload now",
          callback: _uploadCertificate,
        )
      ],
    );
  }

  _uploadCertificate() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['p12'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.extension != 'p12') {
          setState(() {});
          return;
        }
        Uint8List bytes = await _readFileByte(file.path);
        Get.to(
          () => CertificatePassword(bytes, Path.basename(file.path)),
          transition: Transition.noTransition,
        );
      }
    } catch (err) {
      showError(err);
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File certificate = new File.fromUri(myUri);
    Uint8List bytes;
    await certificate.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }
}
