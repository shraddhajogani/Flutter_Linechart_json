import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Speed, String>> seriesBarData;

  _generateData() async {
    final load =
    await DefaultAssetBundle.of(context).loadString("asset/data.json");
    var decoded = json.decode(load);
    List<Speed> sales = [];
    for (var item in decoded) {
      sales.add(Speed.fromJson(item));
    }

    seriesBarData.add(charts.Series(
      data: sales,
      domainFn: (Speed sales, _) => sales.time,
      measureFn: (Speed sales, _) => int.parse(sales.distance),
      id: 'Performance',
    ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    seriesBarData = List<charts.Series<Speed, String>>();
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
            child: charts.BarChart(
              seriesBarData,
              animate: true,
              animationDuration: Duration(seconds: 5),
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