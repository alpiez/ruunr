import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/screens/monthly_runs_detail_screen.dart';
import 'package:ruunr/services/firestore_service.dart';
import 'package:ruunr/widgets/measurement_column.dart';

class MiniMonthlyWidget extends StatelessWidget {
  const MiniMonthlyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    // List<Runs> runsMonth = FirestoreService().getMonthlyDistance(today); //Replaced to just use Consumer<FirestoreService>. Cuz the list is already provided.

    double totalKmMonth(List<Runs> runsMonth) {
      double km = 0;
      if (runsMonth.isEmpty){
        return 0;
      }
      for (var i in runsMonth) {
        km += i.distance;
      }
      return km/1000; 
    }

    Duration totalDurationMonth(List<Runs> runsMonth) {
      Duration time = Duration.zero;
      if (runsMonth.isEmpty){
        return Duration.zero;
      }
      for (var i in runsMonth) {
        time += i.duration;
      }
      return time;
    }

    String calculatePace(Duration duration, double distance, List<Runs> runsMonth) {
      if (runsMonth.isEmpty){
        return "-";
      }
      double paceSeconds = duration.inSeconds.toDouble() / distance;
      int min = (paceSeconds / 60).floor();
      int sec = (paceSeconds % 60).round();
      if ("$min".length >= 2) {
        return "$min";
      }
      return "$min:${sec.toString().padLeft(2, "0")}";
    }

    String stringFormat(double n) {
      if ("$n".length == 6) {
        return n.toStringAsFixed(0);
      }
      return n.toStringAsFixed(1);
    }

    return ElevatedButton(
      onPressed: () { Navigator.pushNamed(context, MonthlyRunDetailScreen.routeName); },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(24, 16, 8, 16),
        primary: const Color(0xff343A40),
        // onPrimary: Color(0xffADB5BD), //this is for button effect thingy, uncomment if u wanna modify effect's color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        )
      ),
      child: Row( //Contains Texts and just a keyboard_arrow_right
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("This Month:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff6C757D))),
              Consumer<FirestoreService>(
                builder: ((context, run, child) {
                  List<Runs> runsMonth = run.getMonthlyDistance(today);
                  return Row(
                    children: [
                      SizedBox(width: 100, child: FittedBox(fit: BoxFit.none, child: MeasurementColumn("Total km", (runsMonth.isEmpty) ? "-" : stringFormat(totalKmMonth(runsMonth)), "km"))),
                      const SizedBox(width: 40),
                      SizedBox(width: 150, child: FittedBox(fit: BoxFit.none, child: MeasurementColumn("Avg Pace", (runsMonth.isEmpty) ? "-" : calculatePace(totalDurationMonth(runsMonth), totalKmMonth(runsMonth), runsMonth), "min/km"))),
                    ],
                  );
                })
              )
            ],
          ),
          const Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
        ],
      ),
    );
  }
}
