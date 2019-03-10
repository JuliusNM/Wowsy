import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wowsy/requests.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context){
    return new Text(
      animation.value.toString(),
      style: new TextStyle(fontSize: 150.0),
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
  AnimationController _controller;

  static int kStartValue = 100;

  _HomeState({Key key, this.fact});
  Future<MathFact> fact;
  int defaultNumber = 0;
  FocusNode _numberFocusNode = new FocusNode();
  final myDateFormat = DateFormat('M/dd');
  DateTime checkDate;
  bool show = true;
  bool random = true;
  bool _visible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultNumber = Random().nextInt(100);
    fact = fetchFact(defaultNumber.toString(), 'math');
    show = true;
    random = true;
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 50),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
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
    Widget myTab(String asset, String text){
      return Tab(icon: image(asset), text: text);
    }

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
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green,), onPressed: (){
                                      AdvancedShare.whatsapp(msg: snapshot.data.body + "")
                                          .then((response) {
                                      });
                                    }),
                                    Text("Share via WhatsApp", style: TextStyle(
                                      fontSize: 8.0
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
                setState(() {
                  _visible = !_visible;
                  random = !_visible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedOpacity(
                  opacity: !random ? 1.0 : 0.8,
                  duration: Duration(milliseconds: 500),
                  child: random ? Card(
                    child: Countdown(
                      animation: new StepTween(
                        begin: 20,
                        end: defaultNumber,
                      ).animate(_controller),
                    ),
                  ): Card(
                    child: target != "date" ? show ? Container(
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
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
                  if(_numberFocusNode.hasFocus){
                    if (value.isNotEmpty) {
                      setState(() {
                        fact = fetchFact(value.toString(), target);
                      });
                    }
                    setState(() {
                      show = false;
                    });
                  }
                },
                onSubmitted: (value){
                  setState(() {
                    if (value.isNotEmpty) {
                      fact = fetchFact(value.toString(), target);
                    }
                    show = true;
                  });
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                onEditingComplete: (){
                  setState(() {
                    show = true;
                  });
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: ()async{
          _controller.forward(from: 0.0).then((_){
            setState(() {
              _visible = !_visible;
              if (!show){
                defaultNumber = Random().nextInt(100);
              }
              fact = fetchFact(defaultNumber.toString(), 'math');
            });
          });
        },
        child: Icon(FontAwesomeIcons.random, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,),
        appBar: AppBar(title: Text("Wowsy"),
          bottom: TabBar(
            labelStyle: TextStyle(fontFamily: "Quicksand"),
            tabs: [
              myTab("assets/albert.png", "Math"),
              myTab("assets/child.png", "Trivia"),
              myTab("assets/calender.png", "Date"),
            ],
          ),),
        body: TabBarView(
          children: [
            math("math"),
            math("trivia"),
            math("date"),
          ],
        ),
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