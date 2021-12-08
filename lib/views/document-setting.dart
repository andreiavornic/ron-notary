import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/document_view.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:notary/widgets/type_notarization.dart';

import 'add-recipient.dart';

class DocumentSetting extends StatefulWidget {
  @override
  _DocumentSettingState createState() => _DocumentSettingState();
}

class _DocumentSettingState extends State<DocumentSetting> {
  TypeNotarization _typeNotarization;
  List<TypeNotarization> _typeNotarizations;
  Session _session;
  String _documentTitle;
  final SessionController _sessionController = Get.put(SessionController());

  initState() {
    _typeNotarizations = [];
    _getNotarization();
    super.initState();
  }

  _getNotarization() async {
    try {
      await _sessionController.getTypeNotarization();
      if (_session != null) {
        _typeNotarization = _typeNotarizations.firstWhere(
            (element) => element.id == _session.typeNotarization.id);
        _documentTitle = _session.sessionFileName;
        setState(() {});
      }
    } catch (err) {
      print(err);
    }
  }

  _addTypeDoc() async {
    try {
      await _sessionController.updateSession(
          _typeNotarization.id, _documentTitle);
      Get.to(
        () => AddRecipient(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    _typeNotarizations = _sessionController.notarizations;
    _session = _sessionController.session.value;
    return Scaffold(
      body: Column(
        children: [
          TitlePage(
            needNav: true,
            needHelp: true,
            title: "Document Settings",
            description: "Indicate type of notarization for eJournal Log",
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DocumentView(),
                SizedBox(height: reSize(30)),
                GetX<SessionController>(
                  init: SessionController(),
                  builder: (controller) {
                    _typeNotarizations = controller.notarizations;
                    _session = controller.session.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => Get.bottomSheet(
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3 +
                                          reSize(34),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        width: reSize(50),
                                        height: reSize(4),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFE0E0E0),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                      SizedBox(height: reSize(20)),
                                      SelectTypeNotarization(
                                        _typeNotarizations,
                                        (TypeNotarization type) {
                                          _typeNotarization = type;
                                          setState(() {});
                                        },
                                        _typeNotarization,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type of Notarization ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xFF161617),
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(height: reSize(7)),
                                  _typeNotarization != null
                                      ? Text(
                                          _typeNotarization.name,
                                          style: TextStyle(
                                            color: Color(0xFF161617),
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                      : Text(
                                          'Choose type of document',
                                          style: TextStyle(
                                            color: Color(0xFFADAEAF),
                                            fontSize: 14,
                                          ),
                                        ),
                                  SizedBox(height: reSize(6)),
                                  Container(
                                    color: Color(0xFFEDEDED),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                            EditInput(
                              onChanged: (value) {
                                _documentTitle = value;
                                setState(() {});
                              },
                              noCapitalize: true,
                              hintText: "Document Title",
                              labelText: "You can rename document here",
                              initialValue: _documentTitle != null &&
                                      _documentTitle.isEmpty
                                  ? _session.sessionFileName
                                  : _documentTitle,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: reSize(50)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: ButtonPrimary(
                text: 'Add Participants',
                callback: _typeNotarization == null ? null : _addTypeDoc,
              ),
            ),
          ),
          SizedBox(
              height:
                  MediaQuery.of(context).size.height < 670 ? 20 : reSize(40)),
        ],
      ),
    );
  }
}
