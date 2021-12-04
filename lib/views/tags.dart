import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:notary/controllers/point.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/point.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/models/user.dart';
import 'package:notary/views/errors/error_page.dart';
import 'package:notary/views/tags/document_body.dart';
import 'package:notary/views/tags/document_tag.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_intput.widget.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/recipient/recipient_list.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'invite.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  UserController _userController = Get.put(UserController());
  RecipientController _recipientController = Get.put(RecipientController());
  PointController _pointController = Get.put(PointController());
  Recipient _userRecipient;
  String _typeSignature;
  String _text;
  bool _canContinue;

  @override
  initState() {
    _typeSignature = "SIGNATURE";
    _canContinue = false;
    getUserData();
    super.initState();
  }

  getUserData() {
    _recipientController.fetchRecipients();
    User _user = _userController.user.value;
    _userRecipient = new Recipient(
      id: _user.id,
      firstName: _user.firstName,
      lastName: _user.lastName,
      isActive: true,
      type: 'NOTARY',
      color: Color(0xFFFFC700),
    );
    _recipientController.addUserRecipient(_userRecipient);
  }

  _addPoint(TapUpDetails details, int page, double wPage) {
    if (_pointController.points.any((element) => element.isChecked)) return;
    Recipient _activeRecipient = _recipientController.recipientsForTag
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
    _pointController.addPoint(newPoint);
    if (_typeSignature == "STAMP") {
      _changeTypeSignature("SIGNATURE");
    }
    _checkContinue();
    _text = null;
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
    _pointController.updatePositionPoint(point, newPosition);
  }

  void _changeTypeSignature(String sign) {
    _typeSignature = sign;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipientController>(
      init: RecipientController(),
      builder: (_recipientController) {
        return Scaffold(
          body: Column(
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
              SizedBox(height: reSize(10)),
              DocumentBody(
                changeTypeSignature: _changeTypeSignature,
                activeRecipient: _recipientController.recipientsForTag
                    .firstWhere((element) => element.isActive),
                typeSignature: _typeSignature,
                editPoint: _editPoint,
                cancelEdit: _pointController.cancelEdit,
                deletePoint: () {
                  _pointController.deletePoint();
                  _checkContinue();
                },
                documentTag: DocumentTag(
                  updatePoint: _updatePoint,
                  addPoint:
                      _typeSignature == "TEXTBOX" ? _addTextBox : _addPoint,
                  checkPoint: _pointController.activatePoint,
                ),
              ),
              SizedBox(height: reSize(20)),
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
                  height: MediaQuery.of(context).size.height < 670
                      ? 20
                      : reSize(40)),
            ],
          ),
        );
      },
    );
  }

  void _checkContinue() {
    List<Point> _points = _pointController.points;
    bool stampExist = _points.any((element) => element.type == "STAMP");

    List<Recipient> signers = _recipientController.recipientsForTag
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
    setState(() {});
  }

  _editPoint() {
    Point point =
        _pointController.points.firstWhere((element) => element.isChecked);
    modalContainer(
        textBoxHandler(point.position, point.page, point.wPage, point.value));
  }

  _addTextBox(TapUpDetails details, int page, double wPage) {
    modalContainer(textBoxHandler(details, page, wPage, null));
  }

  _updateTextBox(String txt) {
    _pointController.editPoint(_text);
    _text = null;
    setState(() {});
  }

  Future<void> _addTagsAndContinue() async {
    try {
      await _pointController.addPoints();
      Get.to(
        () => Invite(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      Get.to(
        () => ErrorPage(
          errorMessage: err.toString(),
          callback: () => Get.back(),
        ),
        transition: Transition.noTransition,
      );
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
              color: Theme.of(context).accentColor,
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
              Get.back();
              if (_text != null) _addPoint(details, page, wPage);
            },
            initialValue: _text,
          ),
          SizedBox(height: 40),
          ButtonPrimary(
            text: txt != null ? "Save Textbox" : "Add Textbox",
            callback: () {
              Get.back();
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
