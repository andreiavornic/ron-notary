import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/widgets/button_primary_outline.dart';

import '../button_primary.dart';
import '../button_recipient.dart';
import '../edit_intput.widget.dart';
import '../loading.dart';
import '../title-modal.dart';

enum TypeRecipient {
  SIGNER,
  WITNESS,
  OBSERVER,
}

class EditRecipient extends StatefulWidget {
  final String id;

  EditRecipient(this.id);

  @override
  _EditRecipientState createState() => _EditRecipientState();
}

class _EditRecipientState extends State<EditRecipient> {
  final RecipientController _recipientController =
      Get.put(RecipientController());
  final GlobalKey<FormState> _formKey = GlobalKey();
  Recipient _recipient;
  String _dropdownError;
  bool _isLoading;
  bool _confirmDelete;
  MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
    initialText: '+1',
  );

  @override
  initState() {
    _isLoading = false;
    _confirmDelete = false;
    super.initState();
  }

  _editRecipient() async {
    _isLoading = true;
    setState(() {});
    try {
      await _recipientController.updateRecipient(_recipient);
      Get.back();
    } catch (err) {
      Get.back();
      showError(err);
    }
    _isLoading = false;
    setState(() {});
  }

  _confirmPopUp() {
    _confirmDelete = true;
    setState(() {});
  }

  _deleteRecipient() async {
    _isLoading = true;
    setState(() {});
    try {
      await _recipientController.deleteRecipient(_recipient?.id);
      Get.back();
    } catch (err) {
      Get.back();
      showError(err);
    }
    _isLoading = false;
    setState(() {});
  }

  _selectTypeRecipient(int index) {
    _recipient.type = TypeRecipient.values[index].toString().split('.').last;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipientController>(
        init: RecipientController(),
        builder: (_recipientController) {
          _recipient = _recipientController.recipients.firstWhere(
              (element) => element.id == widget.id,
              orElse: () => null);
          return Stack(
            children: [
              Container(
                color: Color(0xFFFFFFFF),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleModal(
                          'Edit Participant',
                          'Enter information and set role',
                        ),
                        SizedBox(height: reSize(20)),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  EditInput(
                                    onChanged: (value) {
                                      _recipient?.firstName = value.trim();
                                      setState(() {});
                                    },
                                    autofocus: true,
                                    validate: (String value) {
                                      if (value.trim().isEmpty) {
                                        return "Please enter first name";
                                      }
                                      return null;
                                    },
                                    initialValue: _recipient?.firstName,
                                    labelText: "First Name",
                                  ),
                                  EditInput(
                                    onChanged: (value) {
                                      _recipient?.lastName = value.trim();
                                      setState(() {});
                                    },
                                    validate: (String value) {
                                      if (value.trim().isEmpty) {
                                        return "Please enter last name";
                                      }
                                      return null;
                                    },
                                    initialValue: _recipient?.lastName,
                                    labelText: "Last Name",
                                  ),
                                  EditInput(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      _recipient?.email = value;
                                      setState(() {});
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty &&
                                          _recipient?.phone == null) {
                                        return "Email is required!";
                                      } else if (!value.contains("@") &&
                                          _recipient?.phone == null) {
                                        return "Please add a valid email";
                                      }
                                      return null;
                                    },
                                    initialValue: _recipient?.email,
                                    noCapitalize: true,
                                    labelText: "Email",
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          EditInput(
                                            labelText: "Phone",
                                            inputFormatters: [_phoneFormatter],
                                            initialValue:
                                                _recipient?.phone != null
                                                    ? _recipient?.phone
                                                    : '+1',
                                            prefix: Container(
                                              width: reSize(40),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            hintText: "+1 (234) 567-8901",
                                            validate: (String value) {
                                              return null;
                                            },
                                            onChanged: (String value) async {
                                              _recipient?.phone = value;
                                              setState(() {});
                                            },
                                          ),
                                          Positioned(
                                              bottom: 17,
                                              left: 0,
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: SvgPicture.asset(
                                                          "assets/images/97.svg"),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 1,
                                                      height: 10,
                                                      color: Color(0xFFEDEDED),
                                                    ),
                                                    SizedBox(width: reSize(10)),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: reSize(15)),
                                  Row(
                                    children: [
                                      ButtonRecipient(
                                        isActive: _recipient?.type ==
                                            TypeRecipient.values[0]
                                                .toString()
                                                .split('.')
                                                .last,
                                        txt: 'Signer',
                                        icon: 102,
                                        callback: () => _selectTypeRecipient(0),
                                      ),
                                      SizedBox(width: 10),
                                      ButtonRecipient(
                                        isActive: _recipient?.type ==
                                            TypeRecipient.values[1]
                                                .toString()
                                                .split('.')
                                                .last,
                                        txt: 'Witness',
                                        icon: 103,
                                        callback: () => _selectTypeRecipient(1),
                                      ),
                                      SizedBox(width: 10),
                                      ButtonRecipient(
                                        isActive: _recipient?.type ==
                                            TypeRecipient.values[2]
                                                .toString()
                                                .split('.')
                                                .last,
                                        txt: 'Observer',
                                        icon: 104,
                                        callback: () => _selectTypeRecipient(2),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: reSize(10)),
                                  _dropdownError != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            _dropdownError ?? "",
                                            style: TextStyle(
                                              color: Color(0xFFFF4E4E),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: reSize(0),
                        ),
                        Container(
                          child: ButtonPrimaryOutline(
                            text: 'Delete',
                            callback: _confirmPopUp,
                          ),
                        ),
                        SizedBox(
                          height: reSize(15),
                        ),
                        Container(
                          child: ButtonPrimary(
                            text: 'Confirm',
                            callback: _editRecipient,
                          ),
                        ),
                        SizedBox(height: reSize(40)),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  top: 0,
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    child: Center(
                      child: Loading(),
                    ),
                  ),
                ),
              if (_confirmDelete)
                Positioned.fill(
                  left: 0,
                  top: 0,
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: reSize(80),
                          height: reSize(80),
                          decoration: BoxDecoration(
                            color: Color(0xFFFC563D),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                              child: SvgPicture.asset('assets/images/105.svg')),
                        ),
                        SizedBox(height: reSize(25)),
                        Text(
                          'Are you sure?',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(height: reSize(15)),
                        Text(
                          'You really want to delete participant\n${_recipient?.firstName} ${_recipient?.lastName}?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF494949),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: reSize(50)),
                        ButtonPrimaryOutline(
                          text: 'Delete',
                          callback: _deleteRecipient,
                          width: 232,
                          color: Color(0xFFFC563D),
                        )
                      ],
                    ),
                  ),
                )
            ],
          );
        });
  }
}
