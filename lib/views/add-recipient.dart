import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:notary/controllers/recipient.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/tags.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:notary/widgets/modals/modal_edit_recipient.dart';
import 'package:notary/widgets/modals/modal_new_recipient.dart';
import 'package:notary/widgets/recipient/recipient_item.dart';
import 'package:notary/widgets/title_page.dart';

class AddRecipient extends StatefulWidget {
  @override
  _AddRecipientState createState() => _AddRecipientState();
}

class _AddRecipientState extends State<AddRecipient> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipientController>(
      init: RecipientController(),
      builder: (_recipientController) {
        return Scaffold(
          body: Column(
            children: [
              TitlePage(
                title: 'Add Participants',
                description: 'Information about signers',
                needNav: true,
                needHelp: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        child: TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFFF5F6F9),
                              ),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ))),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: reSize(30),
                                    height: reSize(30),
                                    decoration: BoxDecoration(
                                      color: _recipientController
                                                  .recipients.length >
                                              4
                                          ? Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2)
                                          : Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFFFFFFFF),
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: reSize(15)),
                                  Text(
                                    'Add New',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _recipientController
                                                  .recipients.length >
                                              4
                                          ? Color(0xFF000000).withOpacity(0.2)
                                          : Color(0xFF000000),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onPressed: _recipientController.recipients.length > 4
                              ? null
                              : () => modalContainer(NewRecipient()),
                        ),
                      ),
                      SizedBox(height: reSize(20)),
                      Expanded(
                          child: ListView.separated(
                        shrinkWrap: false,
                        padding: EdgeInsets.all(0),
                        itemCount: _recipientController.recipients.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(
                          height: 1,
                          color: Color(0xFFEDEDED),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                            onPressed: () => modalContainer(
                              EditRecipient(
                                _recipientController.recipients[index].id,
                              ),
                            ),
                            //_navToEdit(index),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 13),
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor.withOpacity(0.1),
                              ),
                            ),
                            child: RecipientItem(
                                _recipientController.recipients[index]),
                          );
                        },
                      )),
                      SizedBox(height: reSize(20)),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Every participant will receive invite to this session.dart',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF646464),
                              ),
                            ),
                            SizedBox(height: reSize(30)),
                            ButtonPrimary(
                              text: _recipientController.recipients.any(
                                      (element) =>
                                          element.type.toLowerCase() ==
                                          "signer")
                                  ? 'Add Tags'
                                  : 'Continue',
                              callback: _recipientController.recipients.any(
                                      (element) => element.type == "SIGNER")
                                  ? () => Get.to(
                                        () => Tags(),
                                        transition: Transition.noTransition,
                                      )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height < 670
                              ? 20
                              : reSize(40)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
