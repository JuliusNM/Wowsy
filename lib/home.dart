import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:wowsy/requests.dart';


class Home extends StatefulWidget {
  final Future<MathFact> fact;

  Home({Key key, this.fact}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<MathFact> fact;

  _HomeState({Key key, this.fact});
  int defaultNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fact = fetchFact(defaultNumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget math = Material(
        child: ListView(
          children: <Widget>[
            Container(
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: NumberPicker.integer(
                        initialValue: defaultNumber,
                        minValue: 0,
                        maxValue: 1000000,
                        onChanged: (newValue) =>
                            setState((){
                              defaultNumber = newValue;
                              fact = fetchFact(defaultNumber.toString());
                            })
                    )
                )
            ),
            Card(
              child: FutureBuilder<MathFact>(
                future: fact,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(snapshot.data.body, style: Theme.of(context).textTheme.title),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value){
                  if (value.isNotEmpty) {
                    setState(() {
                      fact = fetchFact(value.toString());
                    });
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: 'Enter your own number.',
                    border: OutlineInputBorder()

                ),
              ),
            ),

          ],
        )
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text("Wowsy"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: [
            math,
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
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
