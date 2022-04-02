import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/journal.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/journal/item_journal.dart';
import 'package:notary/widgets/edit_input.widget.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';

class Journal extends StatefulWidget {
  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  bool _loading;

  initState() {
    _loading = true;
    _getData();
    super.initState();
  }

  _getData() async {
    try {
      await Provider.of<JournalController>(context, listen: false)
          .getjournals();
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalController>(
      builder: (context, _controller, _) {
        return NetworkConnection(
          LoadingPage(
            _loading,
            _controller.journalSorted.length == 0 &&
                    _controller.journals.length == 0
                ? Container(
                    height: StateM(context).height(),
                    width: StateM(context).width(),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Container(
                            width: StateM(context).width(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'eJournal',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/72.svg',
                                      width: reSize(context, 34),
                                      height: reSize(context, 34),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: reSize(context, 35),
                                ),
                                Text(
                                  'To view details you are required to\ncomplete at least one session',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            child: Column(
                          children: [
                            SizedBox(height: reSize(context, 70)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: reSize(context, 24),
                                          height: reSize(context, 24),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/images/96.svg"),
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
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                : Column(
                    children: [
                      TitlePage(
                        title: "Sessions History",
                        description: "View all sessions",
                        needNav: true,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: EditInput(
                              onChanged: _searchJournal,
                              hintText: 'Type something',
                              labelText: 'Search',
                              suffixIcon: Container(
                                width: 14,
                                height: 14,
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/86.svg',
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _controller.journalSorted.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color:
                                            Color(0xFF494949).withOpacity(0.03),
                                        height: 1,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ItemJournal(
                                        eJournal:
                                            _controller.journalSorted[index],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: reSize(context, 10)),
                              ],
                            ),
                          ),
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
        );
      },
    );
  }

  _searchJournal(String name) {
    Provider.of<JournalController>(context, listen: false).sortJournals(name);
  }
}
