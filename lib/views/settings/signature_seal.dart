import 'package:flutter/material.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/settings/signature_view.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../widgets/network_connection.dart';

class SignatureSeal extends StatefulWidget {
  @override
  _SignatureSealState createState() => _SignatureSealState();
}

class _SignatureSealState extends State<SignatureSeal> {
  AutoScrollController scrollController;

  @override
  void initState() {
    Provider.of<UserController>(context, listen: false).getStamp();
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitlePage(
                needNav: true,
                title: 'Signature & Stamp',
                description: 'Personalize your eSignature & eSeal ',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: SignatureView(),
                    ),
                    SizedBox(
                      height: reSize(context, 50),
                    ),
                    Text(
                      'eSeal',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: reSize(context, 5),
                    ),
                    Text(
                      'Personalize your electronic notary seal',
                      style: TextStyle(
                        color: Color(0xFFADAEAF),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: reSize(context, 20),
                    ),
                    Consumer<UserController>(
                        builder: (context, _controller, _) {
                      return _controller.stamps.length == 0
                          ? LinearProgressIndicator( color: Color(0xFF161617), backgroundColor: Theme.of(context).primaryColor ,)
                          : Container(
                              height: reSize(context, 62),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                controller: scrollController,
                                itemCount: _controller.stamps.length,
                                itemBuilder: (context, index) {
                                  return AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: scrollController,
                                    index: index,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8),
                                      child: TextButton(
                                        onPressed: () => changeStamp(index),
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.zero,
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color(0xFFF6F6F9),
                                            ),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.1),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                                height: reSize(context, 62),
                                                width: reSize(context, 120),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    width: 1.5,
                                                    color: _controller
                                                            .stamps[index]
                                                            .isChecked
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Color(0xFFF6F6F9),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: _controller
                                                      .stamps[index].image,
                                                )),
                                            _controller.stamps[index].isChecked
                                                ? Positioned(
                                                    right: -5,
                                                    top: -5,
                                                    child: Container(
                                                      width:
                                                          reSize(context, 11),
                                                      height:
                                                          reSize(context, 11),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          11,
                                                        ),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        Icons.check,
                                                        size: 8,
                                                        color:
                                                            Color(0xFF161617),
                                                      )),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(width: reSize(context, 10)),
                              ),
                            );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeStamp(int index) async {
    try {
      await Provider.of<UserController>(context, listen: false)
          .selectStamp(index);
    } catch (err) {
      showError(err, context);
    }
  }
}
