import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/session.dart';
import 'package:notary/enum/stage_enum.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/title_stage.dart';
import 'package:notary/widgets/stages_item.dart';

import 'contact.dart';

class Stages extends StatefulWidget {
  @override
  _StagesState createState() => _StagesState();
}

class _StagesState extends State<Stages> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(height: reSize(40)),
            TextButton(
                onPressed: () {
                  showGeneralDialog(
                    barrierLabel: "Label",
                    barrierDismissible: true,
                    barrierColor:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    transitionDuration: Duration(milliseconds: 200),
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: Get.height,
                          width: Get.width - reSize(55),
                          child: Scaffold(
                            backgroundColor: Color(0xFFFFFFFF),
                            body: Padding(
                              padding: const EdgeInsets.only(
                                top: 60,
                                left: 30,
                                bottom: 40,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TitleStage(),
                                        SizedBox(height: reSize(10)),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: reSize(30)),
                                          child: Column(
                                            children: [
                                              StageItem(
                                                needStage:
                                                    Stage.SELECT_DOCUMENT,
                                                title: 'Select Document',
                                                description:
                                                    'Upload docs for this session (phone, cloud, dropbox, drive)',
                                                item: 1,
                                              ),
                                              StageItem(
                                                needStage:
                                                    Stage.DOCUMENT_SETTING,
                                                title: 'Document Settings',
                                                description:
                                                    'Choose document type, rename it',
                                                item: 2,
                                              ),
                                              StageItem(
                                                needStage:
                                                    Stage.ADD_PARTICIPANT,
                                                title: 'Add Participants',
                                                description:
                                                    'Signers, witness and other recipients for current session',
                                                item: 3,
                                              ),
                                              StageItem(
                                                needStage: Stage.TAGS,
                                                title: 'Tags',
                                                description:
                                                    'Set tags for recipients',
                                                item: 4,
                                              ),
                                              StageItem(
                                                needStage: Stage.INVITE,
                                                title: 'Invite',
                                                description:
                                                    'Last step to begin session. Just send invite link to your recipients',
                                                item: 5,
                                                last: true,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: reSize(50)),
                                  Contact()
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                            .animate(anim1),
                        child: child,
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 20),
                  alignment: Alignment.centerRight,
                ),
                child: GetBuilder<SessionController>(builder: (_controller) {
                  return Row(
                    children: [
                      Text(
                        _controller.session.value == null
                            ? ""
                            : '${(_controller.session.value.stage?.index) != null ? (_controller.session.value.stage.index + 1) : 1} / 5',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: reSize(5)),
                      SvgPicture.asset('assets/images/82.svg'),
                    ],
                  );
                })),
          ],
        ),
        SizedBox(width: reSize(30)),
      ],
    );
  }
}
