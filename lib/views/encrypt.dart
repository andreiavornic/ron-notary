import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/process/confirm_delete.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:provider/provider.dart';

import '../widgets/network_connection.dart';
import 'download.dart';

class Encryption extends StatefulWidget {
  @override
  _EncryptionState createState() => _EncryptionState();
}

class _EncryptionState extends State<Encryption> {
  String _passwordEncrypting;
  bool _loading;

  initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
       LoadingPage(
        _loading,
        Consumer<UserController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              child: Container(
                height: StateM(context).height(),
                width: StateM(context).width(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(height: reSize(context, 70)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Encryption",
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: reSize(context, 60)),
                            Container(
                              width: reSize(context, 80),
                              height: reSize(context, 80),
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: SvgPicture.asset('assets/images/109.svg'),
                            ),
                            SizedBox(height: reSize(context, 60)),
                            Column(
                              children: [
                                Text(
                                  "Digital Certificate",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: reSize(context, 10)),
                                Column(
                                  children: [
                                    Text(
                                      controller.passwordCertificate ==
                                          null ||
                                          !controller
                                              .passwordCertificate
                                          ? "Enter your certificate password to encrypt and then download the files"
                                          : "Your certificate is ready for encrypting, with your digital certificate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF494949),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: reSize(context, 55)),
                                  ],
                                ),
                                if (controller.passwordCertificate ==
                                    null ||
                                    !controller.passwordCertificate)
                                  Container(
                                    child: EditInput(
                                      onChanged: (value) {
                                        _passwordEncrypting = value;
                                        setState(() {});
                                      },
                                      obscureText: true,
                                      hintText: 'Certificate password',
                                      labelText: 'Certificate password',
                                      noCapitalize: true,
                                      validator:
                                      "Certificate Password is required",
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                modalContainerSimple(
                                    ConfirmDelete(
                                      callback: _cancelEncryption,
                                      btnTxt: 'Cancel Session',
                                      icon: 107,
                                      description: Text(
                                        'If you Cancel, you will be required to\nstart over',
                                        style: TextStyle(
                                          color: Color(0xFF494949),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    context
                                ),
                            overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                            highlightColor: Colors.transparent,
                            child: Text(
                              'Cancel Encryption',
                              style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: reSize(context, 25)),
                          ButtonPrimary(
                            text: "Encrypt",
                            callback: !controller.passwordCertificate &&
                                (_passwordEncrypting == null ||
                                    _passwordEncrypting.isEmpty)
                                ? null
                                : _encryptDocument,
                          ),
                        ],
                      ),
                      SizedBox(height: StateM(context).height() < 670 ? 20 : reSize(context, 40)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _encryptDocument() async {
    _loading = true;
    setState(() {});
    try {
      await Provider.of<SessionController>(context, listen: false).encryptFile(_passwordEncrypting);
      _loading = false;
      setState(() {});
      StateM(context).navOff(Download());
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _cancelEncryption() async {
    try {
      _loading = true;
      setState(() {});
      Navigator.pop(context);
      await Provider.of<SessionController>(context, listen: false).cancelSession();
      _loading = false;
      setState(() {});
      StateM(context).navOff(Start());

    } catch (err) {
    _loading = false;
    setState(() {});
    showError(err, context);
    }
  }
}
