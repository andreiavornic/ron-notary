import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/title-modal.dart';

import '../button_primary.dart';
import '../button_recipient.dart';
import '../edit_intput.widget.dart';

enum TypeRecipient {
  SIGNER,
  WITNESS,
  OBSERVER,
}

class NewRecipient extends StatefulWidget {
  @override
  _NewRecipientState createState() => _NewRecipientState();
}

class _NewRecipientState extends State<NewRecipient> {
  final RecipientController _recipientController =
      Get.put(RecipientController());
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _selectedRole;
  String _dropdownError;
  bool _enableBtn;
  bool _loading;

  // MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
  //   mask: '+1 (###) ###-####',
  //   filter: {
  //     "#": RegExp(r'[0-9]'),
  //   },
  //   initialText: '+1',
  // );

  MaskTextInputFormatter _phoneFormatter = new MaskTextInputFormatter(
    mask: '+### (##) ###-###',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
    initialText: '+1',
  );

  @override
  initState() {
    _enableBtn = false;
    _loading = false;
    super.initState();
  }

  _verifyBtn() {
    if (_firstName != null &&
        _firstName.isNotEmpty &&
        _lastName != null &&
        _lastName.isNotEmpty &&
        _emailPhoneCheck() &&
        _selectedRole != null) {
      _enableBtn = true;
      setState(() {});
    } else {
      _enableBtn = false;
      setState(() {});
    }
  }

  bool _emailPhoneCheck() {
    if (_email != null && _email.isNotEmpty ||
        _phone != null && _phone.isNotEmpty) return true;
    return false;
  }

  _addRecipient() async {
    try {
      _loading = true;
      setState(() {});

      await _recipientController.addRecipient({
        "firstName": _firstName,
        "lastName": _lastName,
        "phone": _phone,
        "email": _email,
        "type": _selectedRole,
      });
      Get.back();
      _loading = false;
      setState(() {});
    } catch (err) {
      Get.back();
      showError(err);
      Get.back();
      _loading = false;
      setState(() {});
    }
  }

  _selectTypeRecipient(int index) {
    _selectedRole = TypeRecipient.values[index].toString().split('.').last;
    _verifyBtn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: Get.height / 2,
          color: Color(0xFFFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleModal(
                  'New Participant',
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
                              _firstName = value.trim();
                              _verifyBtn();
                              setState(() {});
                            },
                            autofocus: true,
                            validate: (String value) {
                              if (value.trim().isEmpty) {
                                return "Please enter first name";
                              }
                              return null;
                            },
                            initialValue: _firstName,
                            labelText: "First Name",
                          ),
                          EditInput(
                            onChanged: (value) {
                              _lastName = value.trim();
                              _verifyBtn();
                              setState(() {});
                            },
                            validate: (String value) {
                              if (value.trim().isEmpty) {
                                return "Please enter last name";
                              }
                              return null;
                            },
                            initialValue: _lastName,
                            labelText: "Last Name",
                          ),
                          EditInput(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              _email = value;
                              _verifyBtn();
                              setState(() {});
                            },
                            validate: (String value) {
                              if (value.isEmpty && _phone == null) {
                                return "Email is required!";
                              } else if (!value.contains("@") &&
                                  _phone == null) {
                                return "Please add a valid email";
                              }
                              return null;
                            },
                            initialValue: _email,
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
                                    initialValue: _phone != null ? _phone : '',
                                    //  initialValue: _phone != null ? _phone : '+1',
                                    prefix: Container(
                                      width: reSize(40),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    hintText: "+1 (234) 567-8901",
                                    validate: (String value) {
                                      return null;
                                    },
                                    onChanged: (String value) async {
                                      _phone = value;
                                      _verifyBtn();
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
                                isActive: _selectedRole ==
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
                                isActive: _selectedRole ==
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
                                isActive: _selectedRole ==
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
                  child: ButtonPrimary(
                    text: 'Confirm',
                    callback: _enableBtn ? _addRecipient : null,
                  ),
                ),
                SizedBox(height: reSize(40)),
              ],
            ),
          ),
        ),
        if (_loading)
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  child: Center(
                    child: Loading(),
                  ),
                ),
              ))
      ],
    );
  }
}
