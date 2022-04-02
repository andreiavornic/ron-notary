import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/models/session.dart';
import 'package:notary/utils/navigate.dart';
import 'package:provider/provider.dart';

import 'document_pop_up.dart';

class DocumentView extends StatefulWidget {
  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {

  @override
  Widget build(BuildContext context) {

    return Consumer<SessionController>(
        builder: (context, _controller, _) {
          final Session _session = _controller.session;
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.zero,
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFFFFFFFF),
                    ),
                  ),
                  onPressed: () => StateM(context).navTo(DocumentPopUp()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Container(
                          child: Container(
                            width: 125,
                            height: 165,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: _session != null &&
                                        _session.images.length > 0
                                    ? Image.memory(
                                        base64Decode(_session.images[0]))
                                    : Center(
                                        child: Text("Loading..."),
                                      )),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF000000).withOpacity(0.07),
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${_session?.sessionFileName}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
