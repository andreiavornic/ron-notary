import 'package:flutter/material.dart';

import 'package:notary/controllers/point.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/point.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/models/user.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/tags/document_body.dart';
import 'package:notary/views/tags/document_tag.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/recipient/recipient_list.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'invite.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  // UserController Provider.of<UserController>(context, listen: false) = Get.put(UserController());
  // RecipientController Provider.of<RecipientController>(context, listen: false) = Get.put(RecipientController());
  // PointController Provider.of<PointController>(context, listen: false) = Get.put(PointController());
  // SessionController Provider.of<SessionController>(context, listen: false) = Get.put(SessionController());
  Recipient _userRecipient;
  String _typeSignature;
  String _text;
  bool _canContinue;
  bool _loading;

  @override
  initState() {
    _typeSignature = "SIGNATURE";
    _canContinue = false;
    _loading = true;
    _getUserData();
    _getData();
    super.initState();
  }

  _getUserData() {
    User _user = Provider.of<UserController>(context, listen: false).user;
    _userRecipient = new Recipient(
      id: _user.id,
      firstName: _user.firstName,
      lastName: _user.lastName,
      isActive: true,
      type: 'NOTARY',
      color: Color(0xFFFFC700),
    );
    Provider.of<RecipientController>(context, listen: false)
        .addUserRecipient(_userRecipient);
  }

  _getData() async {
    try {
      await Provider.of<PointController>(context, listen: false).getPoints();
      _checkContinue();
    } catch (err) {
      _loading = false;
      setState(() {});
      //  showError(err, context);
    }
  }

  _addPoint(TapUpDetails details, int page, double wPage) {
    if (Provider.of<PointController>(context, listen: false)
        .points
        .any((element) => element.isChecked)) return;
    Recipient _activeRecipient =
        Provider.of<RecipientController>(context, listen: false)
            .recipientsForTag
            .firstWhere((element) => element.isActive);
    var uuid = Uuid();
    Point newPoint = new Point(
      id: uuid.v4(),
      wPage: wPage,
      isChecked: false,
      isSigned: false,
      page: page,
      color: _activeRecipient.color,
      type: _typeSignature,
      ownerId: _activeRecipient.id,
      ownerType: _activeRecipient.type != "NOTARY" ? "RECIPIENT" : "NOTARY",
    );

    newPoint.value = _getValue(_activeRecipient);
    newPoint.position = new Offset(
      details.localPosition.dx - newPoint.value.length * 4,
      details.localPosition.dy - 9,
    );
    Provider.of<PointController>(context, listen: false).addPoint(newPoint);
    if (_typeSignature == "STAMP") {
      _changeTypeSignature("SIGNATURE");
    }
    _checkContinue();
    _text = null;
    setState(() {});
  }

  void _checkContinue() {
    List<Point> _points =
        Provider.of<PointController>(context, listen: false).points;
    bool stampExist = _points.any((element) => element.type == "STAMP");

    List<Recipient> signers =
        Provider.of<RecipientController>(context, listen: false)
            .recipientsForTag
            .where((element) => element.type == "SIGNER")
            .toList();
    List<Point> recipePoints =
        _points.where((point) => point.ownerType == 'RECIPIENT').toList();
    int nrPoints = 0;

    signers.forEach((signer) {
      if (recipePoints.any((point) => point.ownerId == signer.id)) {
        nrPoints += 1;
      }
    });

    bool notarySignExist = _points.any(
        (element) => element.ownerType == "NOTARY" && element.type != "STAMP");
    bool pointSignersExist = signers.length == nrPoints;
    _canContinue = stampExist && pointSignersExist && notarySignExist;
    _loading = false;
    setState(() {});
  }

  _getValue(Recipient activeRecipient) {
    String txt = "${activeRecipient.firstName} ${activeRecipient.lastName}";
    if (_typeSignature == "DATE") {
      txt = DateFormat.yMd().format(DateTime.now()).toString();
    } else if (_typeSignature == "INITIAL") {
      txt = "${activeRecipient.firstName[0]} ${activeRecipient.lastName[0]}";
    } else if (_typeSignature == "TEXTBOX") {
      txt = _text;
    }
    return txt;
  }

  _updatePoint(Point point, DragUpdateDetails data) {
    Offset newPosition = Offset(
        point.position.dx + data.delta.dx, point.position.dy + data.delta.dy);
    Provider.of<PointController>(context, listen: false)
        .updatePositionPoint(point, newPosition);
  }

  void _changeTypeSignature(String sign) {
    _typeSignature = sign;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipientController, PointController>(
        builder: (context, _recipientController, _pointController, _) {
      return NetworkConnection(
        LoadingPage(
            _loading,
            Column(
              children: [
                TitlePage(
                  title: 'Tags',
                  description: 'Select a participant to set tags',
                  needNav: true,
                  needHelp: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RecipientList(() {
                    _typeSignature = "SIGNATURE";
                    setState(() {});
                  }),
                ),
                SizedBox(height: reSize(context, 10)),
                if (Provider.of<RecipientController>(context, listen: false)
                        .recipientsForTag
                        .length !=
                    0)
                  DocumentBody(
                    changeTypeSignature: _changeTypeSignature,
                    activeRecipient:
                        Provider.of<RecipientController>(context, listen: false)
                            .recipientsForTag
                            .firstWhere((element) => element.isActive,
                                orElse: () => null),
                    typeSignature: _typeSignature,
                    editPoint: _editPoint,
                    cancelEdit:
                        Provider.of<PointController>(context, listen: false)
                            .cancelEdit,
                    deletePoint: () {
                      Provider.of<PointController>(context, listen: false)
                          .deletePoint();
                      _checkContinue();
                    },
                    documentTag: DocumentTag(
                      updatePoint: _updatePoint,
                      addPoint:
                          _typeSignature == "TEXTBOX" ? _addTextBox : _addPoint,
                      checkPoint:
                          Provider.of<PointController>(context, listen: false)
                              .activatePoint,
                    ),
                  ),
                SizedBox(height: reSize(context, 20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: ButtonPrimary(
                      callback: _canContinue ? _addTagsAndContinue : null,
                      text: 'Continue',
                    ),
                  ),
                ),
                SizedBox(
                    height: StateM(context).height() < 670
                        ? 20
                        : reSize(context, 40)),
              ],
            )),
      );
    });
  }

  _editPoint() {
    Point point = Provider.of<PointController>(context, listen: false)
        .points
        .firstWhere((element) => element.isChecked);

    modalContainerSimple(
        textBoxHandler(point.position, point.page, point.wPage, point.value),
        context);
  }

  _addTextBox(TapUpDetails details, int page, double wPage) {
    modalContainerSimple(textBoxHandler(details, page, wPage, null), context);
  }

  _updateTextBox(String txt) {
    Provider.of<PointController>(context, listen: false).editPoint(_text);
    _text = null;
    setState(() {});
  }

  Future<void> _addTagsAndContinue() async {
    try {
      _loading = true;
      setState(() {});
      await Provider.of<PointController>(context, listen: false).addPoints();
      Provider.of<SessionController>(context, listen: false)
          .updateStageByString("INVITE");
      StateM(context).navTo(Invite());

      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  Widget textBoxHandler(details, page, wPage, txt) {
    if (txt != null) {
      _text = txt;
      setState(() {});
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Enter your text",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "This text will be inserted into the document",
            style: TextStyle(
              color: Color(0xFFADAEAF),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 40),
          EditInput(
            onChanged: (String value) {
              _text = value;
              setState(() {});
            },
            autofocus: true,
            unfocus: () {
              Navigator.pop(context);
              if (_text != null) _addPoint(details, page, wPage);
            },
            initialValue: _text,
          ),
          SizedBox(height: 40),
          ButtonPrimary(
            text: txt != null ? "Save Textbox" : "Add Textbox",
            callback: () {
              Navigator.pop(context);
              if (_text != null)
                txt != null
                    ? _updateTextBox(_text)
                    : _addPoint(details, page, wPage);
            },
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
