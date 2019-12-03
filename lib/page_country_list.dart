import 'package:country_code/country.dart';
import 'package:country_code/drag_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ItemClickCallback = void Function(Country country);

///
class CountryListPage extends StatefulWidget {

  final ItemClickCallback itemClickCallback;

  CountryListPage({this.itemClickCallback});
  @override
  _CountryListPageState createState() => _CountryListPageState();
}


///
class _CountryListPageState extends State<CountryListPage> {
  var searchController = TextEditingController();
  var searchFocusNode = FocusNode();
  bool showSearch = true;

  String selectLetter = '';
  double offsetDy = 0;
  ScrollController sc = ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if (searchController.text.isEmpty) {
            showSearch = true;
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 48,
              child: Stack(
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(color: Colors.white),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: showSearch,
                      child: GestureDetector(
                        onTap: () {
                          showSearch = false;
                          FocusScope.of(context).requestFocus(searchFocusNode);
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.search,color: Colors.white,),
                              SizedBox(
                                width:10,
                              ),
                              Text(
                                'search',
                                style: TextStyle(
                                  color: Color(0xFF404F66),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              color: Color(0xFF0F1928),
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  ListView(
                    controller: sc,
                    children: _getCountryList(),
                  ),
                  DragLocationWidget(
                    dragLocationCallback: dragLocationCallback,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  ///
  List<Widget> _getCountryList() {
    countryList.sort((a, b) {
      int c = a.index.compareTo(b.index);
      return c != 0 ? c : a.name.compareTo(b.name);
    });

    List<Country> currentCountryList = [];

    String preIndex = '';

    if (searchController.text.isEmpty) {
      currentCountryList.addAll(commonlyUsedCountryList);
      currentCountryList.addAll(countryList);
    } else {
      currentCountryList.addAll(countryList.where((element) {
        return element.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            element.phoneCode.contains(searchController.text.toLowerCase());
      }));
    }

    double tempOffsetDy = 0;
    if (selectLetter.isNotEmpty) {
      int len = currentCountryList.length;
      String _preIndex = '';
      bool hasLetter = true;
      for (int i = 0; i < len; i++) {
        if (currentCountryList[i].index == selectLetter) {
          break;
        }
        if (_preIndex != currentCountryList[i].index) {
          tempOffsetDy += 33;
          _preIndex = currentCountryList[i].index;
        } else {
          tempOffsetDy += 1;
        }
        tempOffsetDy += 44;
        if (i == len - 1) {
          tempOffsetDy = 0;
          hasLetter = false;
        }
      }
      if (hasLetter) {
        offsetDy = tempOffsetDy;
      }
      if (offsetDy >= sc.position.maxScrollExtent) {
        offsetDy = sc.position.maxScrollExtent;
      }

      sc.animateTo(offsetDy,
          duration: Duration(milliseconds: 10), curve: Curves.easeIn);
      setState(() {});
    }

    return List.generate(currentCountryList.length * 2, (index) {
      if (index % 2 == 0) {
        return _dividingLine(preIndex, currentCountryList[index ~/ 2].index);
      } else {
        preIndex = currentCountryList[index ~/ 2].index;
        return GestureDetector(
          onTap: () {
            widget?.itemClickCallback(currentCountryList[index ~/ 2]);
          },
          child: Container(
            color: Color(0xFF0F1928),
            width: MediaQuery.of(context).size.width,
            height: 44,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width:
                      MediaQuery.of(context).size.width - 120,
                  child: Text(
                    currentCountryList[index ~/ 2].name,
                    style: TextStyle(
                      color: Color(0xFF7482A4),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
//                    maxLines: 1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    '+${currentCountryList[index ~/ 2].phoneCode}',
                    style: TextStyle(
                      color: Color(0xFF7482A4),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }).toList();
  }

  ///
  Widget _dividingLine(String preIndex, String curIndex) {
    if (preIndex == curIndex) {
      return Container(
        color: Color(0xFF0F1928),
        height: 1,
        alignment: Alignment.centerLeft,
        child: Container(
          color: Colors.black,
          margin: EdgeInsets.only(left: 15),
        ),
      );
    } else {
      if (curIndex == '#') {
        return Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: 33,
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Container(
                color: Color(0xFF288DDD),
                width: 3,
                height: 13,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Commonly Use',
                  style: TextStyle(
                    color: Color(0xFFD4DCF0),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: 33,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            curIndex,
            style: TextStyle(
              color: Color(0xFFD4DCF0),
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  ///
  void dragLocationCallback(String selectLetter) {
    this.selectLetter = selectLetter;
    if (selectLetter.isNotEmpty) {
      setState(() {});
    }
  }
}
