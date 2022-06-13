import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

class NotaryEdit extends StatefulWidget {
  @override
  _NotaryEditState createState() => _NotaryEditState();
}

class _NotaryEditState extends State<NotaryEdit> {
  String _company;
  String _ronLicense;
  DateTime _ronExpire = DateTime.now();
  String _address;
  String _addressSecond;
  String _city;
  String _zip;
  bool _loading;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
        builder: (context, _controller, _) {
          return LoadingPage(
            _loading,
            Container(
              height: StateM(context).height(),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      TitlePage(
                        title: "Notary Credentials",
                        description: "Must match your notary commission",
                        needNav: true,
                      ),
                      SizedBox(height: reSize(context, 15)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Commissioned Notary in ${_controller.user.longState}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Commission state can be changed in settings',
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Column(
                                  children: [
                                    EditInput(
                                      onChanged: (value) {
                                        _company = value;
                                        setState(() {});
                                      },
                                      labelText: "Company",
                                      initialValue: null,
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: EditInput(
                                            onChanged: (value) {
                                              _ronLicense = value;
                                              setState(() {});
                                            },
                                            validate: (String value) {
                                              if (value.trim().isEmpty) {
                                                return "RON is required";
                                              }
                                              return null;
                                            },
                                            labelText: "RON Commission Number",
                                            initialValue: null,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                            child: InkWell(
                                          onTap: _selectRonExpire,
                                          child: Container(
                                            height: 44,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEDEDED)),
                                            )),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Expiration Date',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF161617),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  DateFormat('MM / dd / yyyy')
                                                      .format(_ronExpire),
                                                  style: TextStyle(
                                                      color: _ronExpire == null
                                                          ? Color(0xFFADAEAF)
                                                          : Color(0xFF161617),
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    EditInput(
                                      onChanged: (value) {
                                        _address = value;
                                        setState(() {});
                                      },
                                      validate: (String value) {
                                        if (value.trim().isEmpty) {
                                          return "Address is required";
                                        }
                                        return null;
                                      },
                                      labelText: "Address",
                                      initialValue: null,
                                    ),
                                    SizedBox(height: 15),
                                    EditInput(
                                      onChanged: (value) {
                                        _addressSecond = value;
                                        setState(() {});
                                      },
                                      labelText: "Address 2 (Optional)",
                                      initialValue: null,
                                    ),
                                    SizedBox(height: 15),
                                    EditInput(
                                      onChanged: (value) {
                                        _city = value;
                                        setState(() {});
                                      },
                                      validate: (String value) {
                                        if (value.trim().isEmpty) {
                                          return "City is required";
                                        }
                                        return null;
                                      },
                                      labelText: "City",
                                      initialValue: null,
                                    ),
                                    SizedBox(height: 15),
                                    EditInput(
                                      onChanged: (value) {
                                        _zip = value;
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.number,
                                      validate: (String value) {
                                        if (value.trim().isEmpty) {
                                          return "ZIP is required";
                                        } else if (value.length < 5 ||
                                            value.length > 6) {
                                          return "ZIP is not match";
                                        }
                                        return null;
                                      },
                                      labelText: "Zip Code",
                                      initialValue: null,
                                      action: TextInputAction.done,
                                    ),
                                    SizedBox(height: reSize(context, 15)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'By selecting Continue, I confirm the above information is true\nand correct',
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 12),
                                      //textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: reSize(context, 15)),
                                    Container(
                                      child: ButtonPrimary(
                                        callback:
                                            !_checkData() ? null : _addNotary,
                                        text: "Continue",
                                      ),
                                    ),
                                    SizedBox(
                                        height: StateM(context).height() < 670
                                            ? 20
                                            : reSize(context, 40)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  bool _checkData() {
    if (_ronLicense != null &&
        _ronLicense.isNotEmpty &&
        _ronExpire != null &&
        _ronExpire != null &&
        _address != null &&
        _address.isNotEmpty &&
        _city != null &&
        _city.isNotEmpty &&
        _zip != null &&
        _zip.isNotEmpty &&
        _zip.length > 4) {
      return true;
    }
    return false;
  }

  _addNotary() async {
    _loading = true;
    setState(() {});
    try {
      await Provider.of<UserController>(context, listen: false).editNotary({
        "company": _company,
        "ronLicense": _ronLicense,
        "ronExpire": _ronExpire.toString(),
        "address": _address,
        "addressSecond": _addressSecond,
        "city": _city,
        "zip": _zip,
      });
      _loading = false;
      setState(() {});
      Navigator.pop(context);
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _selectRonExpire() async {
    await modalContainer(
      Container(
        height: StateM(context).height() / 2,
        color: Color(0xFFFFFFFF),
        child: Column(
          children: [
            Container(
              height: StateM(context).height() / 2 - reSize(context, 100),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumYear: DateTime.now().year,
                minimumDate: DateTime.now(),
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (val) {
                  _ronExpire = val;
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ButtonPrimary(
                text: 'Select expire date',
                callback: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
              ),
            )
          ],
        ),
      ),
        context
    );
  }
}
