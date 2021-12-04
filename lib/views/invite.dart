import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/recipients/document_info.dart';
import 'package:notary/views/recipients/recipient_item.dart';
import 'package:notary/views/session_process.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/title_page.dart';

class Invite extends StatelessWidget {
  final RecipientController _recipientController = Get.put(
    RecipientController(),
  );

  final SessionController _sessionController = Get.put(
    SessionController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TitlePage(
            title: 'Invite',
            description: 'Information about signers',
            needNav: true,
            needHelp: true,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return RecipeItem(
                                  _recipientController.recipients[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 1,
                                color: Color(0xFFE8EAF0),
                              );
                            },
                            itemCount: _recipientController.recipients.length)),
                  ),
                  SizedBox(height: reSize(15)),
                  _getDoc(),
                  SizedBox(height: reSize(25)),
                  Expanded(
                    child: Container(
                      height: 1,
                    ),
                  ),
                  Container(
                    width: Get.width - reSize(60),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/images/65.svg",
                          color: Color(0xFFFC563D),
                        ),
                        SizedBox(width: reSize(10)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'By selecting Send Invite I confirm that I have the correct document and participants, and I know no changes will be allowed',
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: reSize(25)),
                  Container(
                    child: ButtonPrimary(
                      text: 'Send Invite',
                      callback: _inviteParticipants,
                    ),
                  ),
                  SizedBox(
                    height: Get.height < 670 ? 20 : reSize(40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _inviteParticipants() async {
    try {
      await _sessionController.startSession();
      Get.to(
        () => SessionProcess(),
        transition: Transition.noTransition,
      );
    } catch (err) {
      showError(err);
    }
  }

  Widget _getDoc() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: DocumentInfo(),
        );
      },
    );
  }
}
