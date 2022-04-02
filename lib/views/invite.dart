import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/recipient.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/recipients/document_info.dart';
import 'package:notary/views/recipients/recipient_item.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

class Invite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<RecipientController, SessionController, UserController>(
        builder: (context, _recipientController, _sessionController,
            _userController, _) {
      return NetworkConnection(
        Scaffold(
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
                                      Provider.of<RecipientController>(context,
                                              listen: false)
                                          .recipients[index]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 1,
                                    color: Color(0xFFE8EAF0),
                                  );
                                },
                                itemCount: Provider.of<RecipientController>(
                                        context,
                                        listen: false)
                                    .recipients
                                    .length)),
                      ),
                      SizedBox(height: reSize(context, 15)),
                      _getDoc(),
                      SizedBox(height: reSize(context, 25)),
                      Expanded(
                        child: Container(
                          height: 1,
                        ),
                      ),
                      Container(
                        width: StateM(context).width() - reSize(context, 60),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/images/65.svg",
                              color: Color(0xFFFC563D),
                            ),
                            SizedBox(width: reSize(context, 10)),
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
                      SizedBox(height: reSize(context, 25)),
                      Container(
                        child: ButtonPrimary(
                          text: 'Send Invite',
                          callback: () => _inviteParticipants(context),
                        ),
                      ),
                      SizedBox(
                        height: StateM(context).height() < 670
                            ? 20
                            : reSize(context, 40),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _inviteParticipants(context) async {
    try {
      await Provider.of<SessionController>(context, listen: false)
          .startSession();
      await Provider.of<UserController>(context, listen: false)
          .updatePayment(0);
      StateM(context).navOff(Start());
    } catch (err) {
      showError(err, context);
    }
  }

  Widget _getDoc() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DocumentInfo();
      },
    );
  }
}
