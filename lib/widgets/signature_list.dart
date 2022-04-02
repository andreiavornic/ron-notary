import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:provider/provider.dart';

import 'button_primary.dart';

class SignatureList extends StatefulWidget {
  @override
  _SignatureListState createState() => _SignatureListState();
}

class _SignatureListState extends State<SignatureList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, _) {
        return Container(
          color: Color(0xFFFFFFFF),
          height: StateM(context).height() / 2,
          width: StateM(context).width(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Choose Signature",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: reSize(context, 2)),
                Text(
                  "Select preferred style",
                  style: TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: reSize(context, 30)),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: controller.signatures.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(
                      height: reSize(context, 1),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFFDFDFD),
                          Color(0xFFF4F4F4),
                        ],
                      )),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        onPressed: () {
                          controller.selectSignature(index);
                          setState(() {});
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary.withOpacity(0.03)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Container(
                          height: reSize(context, 56),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${controller.user.firstName} ${controller.user.lastName}, ${controller.user.firstName[0]}.${controller.user.lastName[0]}.",
                                  style: GoogleFonts.getFont(
                                    controller.signatures[index].textFont,
                                    fontSize: 15,
                                    //    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              controller.signatures[index].isChecked
                                  ? Container(
                                      width: reSize(context, 14),
                                      height: reSize(context, 14),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF5B5BFF)
                                                .withOpacity(0.12),
                                            blurRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Color(0xFF000000)
                                                .withOpacity(0.04),
                                            blurRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 10,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: reSize(context, 14),
                                      height: reSize(context, 14),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: reSize(context, 20)),
                ButtonPrimary(
                  text: "Confirm",
                  callback: () {
                    controller.saveSignature();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: reSize(context, 40)),
              ],
            ),
          ),
        );
      },
    );
  }
}
