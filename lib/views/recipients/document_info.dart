import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/document_pop_up.dart';

class DocumentInfo extends StatefulWidget {
  @override
  _DocumentInfoState createState() => _DocumentInfoState();
}

class _DocumentInfoState extends State<DocumentInfo> {
  SessionController _sessionController = Get.put(SessionController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF6F6F9), borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: reSize(54),
                    height: reSize(72),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Color(0xFF000000).withOpacity(0.07),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () => Get.to(()=> DocumentPopUp()),
                        child: Image.memory(
                          base64Decode(
                              _sessionController.session.value.images[0]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width - 200,
                        child: Text(_sessionController.session.value.sessionFileName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: Get.width - 200,
                        child: Text(
                          'Type: ${_sessionController.session.value.typeNotarization.name}',
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFA4A4A4),
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
