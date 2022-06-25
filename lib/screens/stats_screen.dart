import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/screens/runs_all_screen.dart';
import 'package:ruunr/widgets/measurement_column.dart';
import 'package:ruunr/widgets/runs_data_listview.dart';

class StatsScreen extends StatefulWidget {
  static String routeName = "/stats";

  StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Runs> allRuns = AllRunsData.allRuns;

  @override
  Widget build(BuildContext context) {

    double totalDistance() {
      double dist = 0;
      for (var i in allRuns) {
        dist += i.distance;
      }
      return dist / 1000;
    }
    
    Duration totalDuration() {
      Duration dura = const Duration(seconds: 0);
      for (var i in allRuns) {
        dura += i.duration;
      }
      return dura;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Activities")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          Container(
            height: 240,
            alignment: Alignment.center,
            child: const Text("Chart here lol"),
            decoration: const BoxDecoration(color: Color(0xff343A40)),
          ),
          const SizedBox(height: 20),
          Wrap(
             spacing: 30,
              runSpacing: 30,
            children: [
              MeasurementColumn("Total km", totalDistance().toStringAsFixed(1), "km", mainSize: 50),
              MeasurementColumn("Total duration", totalDuration().inHours.toString(), "hours", mainSize: 50),
            ],
          ),
          const SizedBox(height: 50),
          const Text("All Runs", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
          ElevatedButton(
            onPressed: () => { Navigator.pushNamed(context, RunsScreen.routeName) },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Search/filter runs", style: TextStyle(color: Color(0xffADB5BD))),
                Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
              ],
            ),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: Size(double.infinity,54), primary: Color(0xff343A40)),
          ),
          RunDataListview(allRuns, listsLimit: 5)
        ]
      ),
    );
  }
}
