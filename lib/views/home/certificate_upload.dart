import 'dart:io';
import 'dart:typed_data';
import 'package:notary/utils/navigate.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['p12', 'pfx'],
      );
      if (result != null) {
        File file = File(result.files.single.path);
        var extension = Path.extension(file.path);
        if (extension != '.p12' && extension != '.pfx') {
          setState(() {});
          return;
        }
        Uint8List bytes = await _readFileByte(file.path);
        StateM(context).navTo(CertificatePassword(bytes, Path.basename(file.path)));

      }
    } catch (err) {
      showError(err, context);
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File certificate = new File.fromUri(myUri);
    Uint8List bytes;
    try {
      var value = await certificate.readAsBytes();
      bytes = Uint8List.fromList(value);
      return bytes;
    } catch (err) {
      throw err;
    }
  }
}
