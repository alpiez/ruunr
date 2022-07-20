import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/widgets/measurement_column.dart';
import 'package:ruunr/widgets/runs_data_listview.dart';

class MonthlyRunDetailScreen extends StatelessWidget {
  static String routeName = "/monthruns";
  const MonthlyRunDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<Runs> runsMonth = AllRunsData().getMonthlyDistance(today);

    double totalKmMonth() {
      double km = 0;
      for (var i in runsMonth) {
        km += i.distance;
      }
      return km/1000; 
    }

    Duration totalDurationMonth() {
      Duration time = Duration.zero;
      for (var i in runsMonth) {
        time += i.duration;
      }
      return time;
    }

    String calculatePace(Duration duration, double distance) {
      double paceSeconds = duration.inSeconds.toDouble() / distance;
      int min = (paceSeconds / 60).floor();
      int sec = (paceSeconds % 60).round();
      if ("$min".length >= 2) {
        return "$min";
      }
      return "$min:${sec.toString().padLeft(2, "0")}";
    }

    String stringFormat(double n) {
      if ("$n".length == 5) {
        return n.toStringAsFixed(0);
      }
      return n.toStringAsFixed(1);
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat("MMMM y").format(today))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          const Text("Analysis", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: [
              MeasurementColumn("Total km", stringFormat(totalKmMonth()), "km"),
              MeasurementColumn("Avg Pace", calculatePace(totalDurationMonth(), totalKmMonth()), "min/km")
              // MeasurementColumn("Calories", "208", "kcal"),
            ],
          ),
          const SizedBox(height: 50),
          const Text("All Runs", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
          RunDataListview(runsMonth)
        ],
      ),
    );
  }
}