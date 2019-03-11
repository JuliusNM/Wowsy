import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wowsy/requests.dart';
//import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
      duration: new Duration(seconds: 1),
    );
    _controller.forward(from: 0.0);
    ///Ads
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-9224488061407666~7709742861");
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['numbers', 'games', 'fact', 'birthdays', 'trivia', 'math'],
      contentUrl: 'https://flutter.io',
      childDirected: true,
      testDevices: <String>["0CA7E71F2370FCB05A2496966E5B445D"],
    );
    BannerAd myBanner = BannerAd(
      adUnitId: "ca-app-pub-9224488061407666/6041437971",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    BannerAd myInterstitial = BannerAd(
      adUnitId: "ca-app-pub-9224488061407666/6249090021",
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
      myBanner
        ..load()
        ..show(
          anchorOffset: 0.0,
          anchorType: AnchorType.bottom,
        );
      Future.delayed(const Duration(seconds: 60), (){
        myInterstitial
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
            anchorOffset: 0.0,
          );
      });
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
                                    IconButton(icon: Icon(FontAwesomeIcons.shareAlt, color: Colors.green,), onPressed: (){
                                      Share.share('');
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
                                Icon(Icons.edit)
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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