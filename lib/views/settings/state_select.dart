import 'package:flutter/cupertino.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:provider/provider.dart';
import 'package:us_states/us_states.dart';

class StateSelect extends StatefulWidget {
  final Function changeState;
  final isSetting;

  StateSelect({this.changeState, this.isSetting});

  @override
  _StateSelectState createState() => _StateSelectState();
}

class _StateSelectState extends State<StateSelect> {
  int _stateSelected;
  int _defaultState;

  List<String> _cities;

  @override
  void initState() {
    _cities = USStates.getAllNames();
    List<String> citiesAbrv = USStates.getAllAbbreviations();
    int index = 0;
    if (widget.isSetting != null && widget.isSetting) {
      if (Provider.of<UserController>(context, listen: false).notary != null) {
        index = citiesAbrv.indexWhere((element) =>
            element ==
            Provider.of<UserController>(context, listen: false).notary.state);
      }
    }

    _stateSelected = index;
    _defaultState = index;
    super.initState();
  }

  _selectState() {
    print("_selectState() => Executed!");
    String selectedCity = _cities[_stateSelected];
    String abbrevCity = USStates.getAbbreviation(selectedCity);
    widget.changeState(abbrevCity, selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: StateM(context).height() / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      )),
      child: Column(
        children: [
          Text(
            'Select state',
            style: TextStyle(
              color: Color(0xFFF161617),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: reSize(context, 15)),
          Text(
            'Select the state where is your notarial license.',
          ),
          SizedBox(height: reSize(context, 20)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoPicker(
                itemExtent: 52,
                scrollController: FixedExtentScrollController(
                  initialItem: _defaultState,
                ),
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFCDCDCD),
                    ),
                  ),
                ),
                children: USStates.getAllAbbreviations().map((item) {
                  return Container(
                    height: 52,
                    child: Center(
                      child: Text(
                        USStates.getName(item),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF494949),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onSelectedItemChanged: (int index) {
                  print(index);
                  _stateSelected = index;
                  // setState(() {});
                },
              ),
            ),
          ),
          SizedBox(height: reSize(context, 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonPrimary(
              text: 'Select',
              callback: _selectState,
            ),
          ),
          SizedBox(
              height:
                  StateM(context).height() < 670 ? 20 : reSize(context, 40)),
        ],
      ),
    );
  }
}
