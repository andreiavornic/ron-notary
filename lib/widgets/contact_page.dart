import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/support.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'button_primary.dart';
import 'confirm_message.dart';
import 'edit_input.widget.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String _msg;
  final _formKeyScreen = GlobalKey<FormState>();

  Future<void> _sendMessage() async {
    try {
      await Provider.of<SupportController>(context, listen: false)
          .addMessage({"request": _msg});
      StateM(context).navTo(ConfirmMessage());
      _msg = null;
      _formKeyScreen.currentState.reset();
      setState(() {});
    } catch (err) {
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Container(
          height: StateM(context).height(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: reSize(context, 70)),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      child: Row(
                        children: [
                          Container(
                            width: reSize(context, 24),
                            height: reSize(context, 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SvgPicture.asset("assets/images/96.svg"),
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get in touch if you need help",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: reSize(context, 30)),
                      Row(
                        children: [
                          Text(
                            "Your support manager:",
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: reSize(context, 5)),
                          Text(
                            " Nicolas",
                            style: TextStyle(
                              color: Color(0xFF20303C),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: reSize(context, 30)),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => launch("tel:+18727662792"),
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: reSize(context, 60),
                              height: reSize(context, 60),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                      "assets/images/117.svg")),
                            ),
                          ),
                          SizedBox(width: reSize(context, 20)),
                          InkWell(
                            onTap: () => launch("sms:+37369385286"),
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: reSize(context, 60),
                              height: reSize(context, 60),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                "assets/images/118.svg",
                                width: reSize(context, 24),
                              )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Or send us a message",
                        style: TextStyle(
                          color: Color(0xFF20303C),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKeyScreen,
                        child: EditInput(
                          hintText: "Type anything",
                          labelText: "Message",
                          onChanged: (String value) {
                            _msg = value;
                            setState(() {});
                          },
                          action: TextInputAction.next,
                          onFieldSubmitted: _sendMessage,
                        ),
                      )
                    ],
                  ),
                ),
                ButtonPrimary(
                  callback: _msg == null || _msg.isEmpty ? null : _sendMessage,
                  text: "Send Message",
                ),
                SizedBox(height: reSize(context, 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
