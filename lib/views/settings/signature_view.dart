import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';

class SignatureView extends StatefulWidget {
  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (_controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: reSize(20)),
              Text(
                'Signature & Initials',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(height: reSize(15)),
              Text(
                'I agree that the Signature and my Initials will be my electronic signature and initials, and when applied on a document at my direction, they will be just as legally binding as my pen-and-ink signature and initials.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF494949),
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: reSize(30),
              ),
              TextButton(
                onPressed: () => null,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  overlayColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor.withOpacity(0.1),
                  ),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      color: Colors.transparent,
                      fontSize: 12,
                    ),
                  ),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'eSignature',
                          style: TextStyle(
                            color: Color(0xFF20303C),
                          ),
                        ),
                        _controller.signatures == null
                            ? Container(
                                height: 2,
                                child: LinearProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  minHeight: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_controller.user.value.firstName} ${_controller.user.value.lastName}, ${_controller.user.value.firstName[0]}.${_controller.user.value.lastName[0]}.",
                                    style: GoogleFonts.getFont(
                                      _controller.signatures[indexSelected].textFont,
                                      fontSize: 15,
                                      //    fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/images/73.svg",
                                    color: Color(0xFF20303C),
                                  )
                                ],
                              ),
                        SizedBox(height: reSize(5)),
                        Container(
                          height: 1,
                          color: Color(0xFFEDEDED),
                        )
                      ],
                    )),
              )
            ],
          );
        });
  }
}
