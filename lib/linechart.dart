import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Speed, int>> seriesBarData;
// 1. Change it String to int --> get this error: The getter 'time' isn't defined for the type 'List<Speed>'.
  _generateData() async {
    final load =
    await DefaultAssetBundle.of(context).loadString("asset/data.json");
    var decoded = json.decode(load);
    List<Speed> speed = [];
    for (var item in decoded) {
      speed.add(Speed.fromJson(item));
    }

    seriesBarData.add(charts.Series(
      data: speed,
      domainFn: (Speed speed, _) => int.parse(speed.time),
      // 2.domainFn: (Speed speed, _) => speed.time, (Parse it with int)
      measureFn: (Speed speed, _) => int.parse(speed.distance),
      // 3. measureFn: (Speed speed, _) => int.parse(speed.distance), Parse it with int
      id: 'Performance',
    ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    seriesBarData = List<charts.Series<Speed, int>>();
    // 4. Change here String to int
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child: Text('flutter charts')),
      ),
      body: Column(
        children: [
          Text(
            'Distance to Lane',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          seriesBarData.length > 0
              ? Expanded(
            child: charts.LineChart(
              seriesBarData,
              animate: true,
              animationDuration: Duration(seconds: 20),
              behaviors: [

                new charts.ChartTitle('Time,seconds',
                behaviorPosition: charts.BehaviorPosition.bottom,
                  //5. Added Title to Axis

                ),
            new charts.ChartTitle('Distance,meter',
            behaviorPosition: charts.BehaviorPosition.start,
            )
              ],
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}

class Speed {
  String time;
  String distance;

  Speed(this.time, this.distance);

  Speed.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    distance = json['distance'];
  }
}