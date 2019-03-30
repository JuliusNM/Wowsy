import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wowsy/requests.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:share/share.dart';

class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context){
    return new Text(
      animation.value.toString(),
      style: Theme.of(context).textTheme.headline,
    );
  }
}

class Home extends StatefulWidget{

  final Future<MathFact> fact;
  Home({Key key, this.fact}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  _HomeState({Key key, this.fact});
  AnimationController _controller;
  Future<MathFact> fact;
  static int kStartValue = 100;
  int defaultNumber = 0;
  FocusNode _numberFocusNode = new FocusNode();
  final myDateFormat = DateFormat('M/dd');
  DateTime checkDate;
  bool show = true;
  bool random = true;
  bool _visible = true;

  final  List<Tab> myTabs = <Tab>[
    Tab(icon: Image(
        image: AssetImage("assets/albert.png"),
        color: null,
        fit: BoxFit.scaleDown,
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center
    ), text: "Math"),
    Tab(icon: Image(
        image: AssetImage("assets/child.png"),
        color: null,
        fit: BoxFit.scaleDown,
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center
    ), text: "Trivia"),
    Tab(icon: Image(
        image: AssetImage("assets/calender.png"),
        color: null,
        fit: BoxFit.scaleDown,
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center
    ), text: "Date"),
  ];

  hideNumberWidget(){
    if(_numberFocusNode.hasFocus){
      setState(() {
        show = false;
      });
    }
  }
  showNumberWidget(){
      setState(() {
        show = true;
      });
  }
  toggleWidget(){
    setState(() {
      _visible = !_visible;
      random = !_visible;
    });
  }
  Widget image(String asset){
    return Image(
        image: AssetImage(asset),
        color: null,
        fit: BoxFit.scaleDown,
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center
    );
  }

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        print(_tabController.index);
        if(_tabController.index == 1){
          setState(() {
            fact = fetchFact(defaultNumber.toString(), "trivia");
          });
        }
        else if(_tabController.index == 2){
          setState(() {
            fact = fetchFact(defaultNumber.toString(), "date");
          });
        }
        else if (_tabController.index == 0){
          setState(() {
            fact = fetchFact(defaultNumber.toString(), "math");
          });
        }
      }
    });

    defaultNumber = Random().nextInt(100);
    fact = fetchFact(defaultNumber.toString(), 'math');
    show = true;
    random = true;
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 1),
    );
    _controller.forward(from: 0.0);
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget math (String target) {
      return Material(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0.5,
                child: AnimatedContainer(
                  duration: Duration(seconds: 5),
                  child: FutureBuilder<MathFact>(
                    future: fact,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimatedContainer(
                          duration: Duration(seconds: 5),
                          child: ListTile(
                            title: Text(snapshot.data.body, style: Theme.of(context).textTheme.title),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(icon: Icon(FontAwesomeIcons.shareAlt, color: Colors.green,), onPressed: (){
                                      Share.share(snapshot.data.body.toString() + "Download Wowsy App to see more interesting facts."+
                                          "\nhttps://play.google.com/store/apps/details?id=com.jellosolutions.wowsy");
                                    }),
                                    Text("Share", style: TextStyle(
                                      fontSize: 10.0
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("We're having trouble connecting to the server. Please check your internet connection.", style: Theme.of(context).textTheme.title,),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Loading...", style: Theme.of(context).textTheme.title,),
                      );
                    },
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                toggleWidget();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedOpacity(
                  opacity: !random ? 1.0 : 0.8,
                  duration: Duration(milliseconds: 500),
                  child: random ? show ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.edit, color: Colors.green,)
                              ],
                            ),
                            Center(
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      _controller.forward(from: 0.0).then((_){
                                        setState(() {
                                          fact = fetchFact(defaultNumber.toString(), target);
                                        });
                                      });
                                    },
                                    child: Countdown(
                                      animation: new StepTween(
                                        begin: Random().nextInt(100),
                                        end: defaultNumber,
                                      ).animate(_controller),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ):Container(): Card(
                    child: target != "date" ? show ? Container(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NumberPicker.integer(
                                initialValue: defaultNumber,
                                minValue: 0,
                                maxValue: 1000000,
                                onChanged: (newValue) =>
                                    setState((){
                                      defaultNumber = newValue;
                                      fact = fetchFact(defaultNumber.toString(), target);
                                    })
                            )
                        )
                    ): Container():
                    FlatButton(onPressed: (){
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      locale: 'en',
                      onChanged: (date) {
                        print('change $date');
                        setState(() {
                          fact = fetchFact(myDateFormat.format(date).toString(), target);
                        });
                      },
                      onConfirm: (date){
                        setState(() {
                          fact = fetchFact(myDateFormat.format(date).toString(), target);
                        });
                      },
                    );
                    }, child: ListTile(
                    title: Text("Choose Date"),
                    subtitle: Text("Find facts about specific dates"),
                    trailing: image("assets/calender.png"),
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: target != "date" ? show ? Text("Quick Search ?"): Container(): Container(),
            ),
            target != "date" ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                focusNode: _numberFocusNode,
                onChanged: (value){
                  hideNumberWidget();
                    if (value.isNotEmpty) {
                      setState(() {
                        fact = fetchFact(value.toString(), target);
                      });
                    }
                },
                onSubmitted: (value){
                  setState(() {
                    if (value.isNotEmpty) {
                      fact = fetchFact(value.toString(), target);
                    }
                    showNumberWidget();
                  });
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                onEditingComplete: (){
                  showNumberWidget();
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: 'Quick Search',
                    border: OutlineInputBorder()

                ),
              ),
            ): Container(),

          ],
        )
    );
    }
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          math("math"),
          math("trivia"),
          math("date"),
        ],
      ),
    );
  }
}
class MathFact {
  final String body;
  MathFact({this.body});
  factory MathFact.fromJson(json) {
    print(json);
    return MathFact(
      body: json.toString()
    );
  }
}