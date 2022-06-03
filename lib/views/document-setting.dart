import 'package:flutter/material.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/session.dart';
import 'package:notary/models/type_notarization.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/document_view.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:notary/widgets/type_notarization.dart';
import 'package:provider/provider.dart';

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
  bool _loading;

  initState() {
    _loading = true;
    _typeNotarizations = [];
    _getNotarization();
    super.initState();
  }

  _getNotarization() async {
    try {
      await Provider.of<SessionController>(context, listen: false)
          .getTypeNotarization();
      Provider.of<SessionController>(context, listen: false)
          .updateStageByString("DOCUMENT_SETTING");
      if (_session != null && _session.typeNotarization != null) {
        _typeNotarization = _typeNotarizations.firstWhere(
            (element) => element.id == _session.typeNotarization.id);
      }
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _addTypeDoc() async {
    try {
      _loading = true;
      setState(() {});
      await Provider.of<SessionController>(context, listen: false)
          .updateSession(_typeNotarization.id, _documentTitle);
      Provider.of<SessionController>(context, listen: false)
          .updateStageByString("ADD_PARTICIPANT");
      StateM(context).navTo(AddRecipient());
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      LoadingPage(
        _loading,
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: StateM(context).height(),
              child: Column(
                children: [
                  TitlePage(
                    needNav: true,
                    needHelp: true,
                    title: "Document Settings",
                    description:
                        "Indicate type of notarization for eJournal Log",
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DocumentView(),
                        SizedBox(height: reSize(context, 30)),
                        Consumer<SessionController>(
                          builder: (context, controller, _) {
                            _typeNotarizations = controller.notarizations;
                            _session = controller.session;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () => modalContainerSimple(
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFFF),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
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
                                          context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Type of Notarization ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Color(0xFF161617),
                                              fontSize: 10,
                                            ),
                                          ),
                                          SizedBox(height: reSize(context, 7)),
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
                                          SizedBox(height: reSize(context, 6)),
                                          Container(
                                            color: Color(0xFFEDEDED),
                                            width: StateM(context).width() - 40,
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
                                      initialValue: _documentTitle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: reSize(context, 50)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      child: ButtonPrimary(
                        text: 'Add Participants',
                        callback:
                            _typeNotarization == null ? null : _addTypeDoc,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: StateM(context).height() < 670
                          ? 20
                          : reSize(context, 40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
