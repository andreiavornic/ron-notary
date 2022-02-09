import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/process/document_tag_session.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/modals/modal_container.dart';

import 'button_primary_outline.dart';
import 'confirm_delete.dart';
import 'loading_page.dart';

class DocumentPopUp extends StatefulWidget {
  @override
  _DocumentPopUpState createState() => _DocumentPopUpState();
}

class _DocumentPopUpState extends State<DocumentPopUp> {
  bool _isLoading;
  SessionController _sessionController = Get.put(SessionController());

  initState() {
    _isLoading = false;
    super.initState();
  }

  _deleteSession() async {
    _isLoading = true;
    setState(() {});
    try {
      Get.back();
      await _sessionController.deleteSession();
      Get.offAll(
        () => Start(),
        transition: Transition.noTransition,
      );
      _isLoading = false;
      setState(() {});
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      _isLoading,
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 40),
        child: Container(
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Document Preview',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Uploaded documents',
                    style: TextStyle(
                      color: Color(0xFF20303C),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF000000).withOpacity(0.09),
                      width: 1,
                    ),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Color(0xFF000000).withOpacity(0.05),
                      child: Stack(
                        children: [
                          DocumentTagSession(),
                          Positioned(
                            left: 17,
                            bottom: 17,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: TextButton(
                                onPressed: () => modalContainer(ConfirmDelete(
                                  callback: () => _deleteSession(),
                                )),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    Color(0xFFFFFFFF).withOpacity(0.09),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/106.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              ButtonPrimaryOutline(
                text: 'Go Back',
                callback: () => Get.back(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
