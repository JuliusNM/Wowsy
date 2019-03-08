import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wowsy/requests.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class Home extends StatefulWidget {
  final Future<MathFact> fact;
  Home({Key key, this.fact}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState({Key key, this.fact});
  Future<MathFact> fact;
  int defaultNumber = Random().nextInt(100);
  FocusNode _numberFocusNode = new FocusNode();
  final myDateFormat = DateFormat('M/dd');
  DateTime checkDate;
  bool show = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fact = fetchFact(defaultNumber.toString(), 'math');
    show = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget math (String target) {
      return Material(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: Duration(seconds: 5),
                child: Card(
                  elevation: 0.5,
                  child: FutureBuilder<MathFact>(
                    future: fact,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
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
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("We're having trouble connecting to the server", style: Theme.of(context).textTheme.title,),
                        );
                      }
                      return Text("Loading...");
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: .5,
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
                ): Container(): Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimePickerFormField(
                    dateOnly: true,
                    decoration: InputDecoration(
                        helperText: "Select a date to lookup",
                        labelText: 'Date', border: OutlineInputBorder(),hintText: "Select date", hintStyle: TextStyle(
                        color: Colors.grey
                    )),
                    format: myDateFormat,
                    onChanged: (dt){
                      setState(() {
                        fact = fetchFact(myDateFormat.format(dt).toString(), target);
                      });
                    },
                    editable: false,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: target != "date" ? Text("Quick Search ?"): Container(),
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
        appBar: AppBar(title: Text("Wowsy"),
          bottom: TabBar(
            labelStyle: TextStyle(fontFamily: "Quicksand"),
            tabs: [
              Tab(icon: Image(
                image: AssetImage("assets/albert.png"),
                color: null,
                fit: BoxFit.scaleDown,
                height: 35.0,
                width: 35.0,
                alignment: Alignment.center,
              ), text: "Math",),
              Tab(icon: Image(
                image: AssetImage("assets/child.png"),
                color: null,
                fit: BoxFit.scaleDown,
                height: 35.0,
                width: 35.0,
                alignment: Alignment.center,
              ), text: "Trivia",),
              Tab(icon: Image(
                image: AssetImage("assets/calender.png"),
                color: null,
                fit: BoxFit.scaleDown,
                height: 35.0,
                width: 35.0,
                alignment: Alignment.center,
              ), text: "Date",),
            ],
          ),),
        backgroundColor: Colors.black,
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
