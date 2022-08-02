import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/screens/runs_data_detail_screen.dart';
import 'package:ruunr/services/firestore_service.dart';

class MiniRunDataWidget extends StatelessWidget {
  List<Runs> allRuns;
  int i;
  MiniRunDataWidget(this.allRuns, this.i, {Key? key}) : super(key: key);

  calculatePace(Duration duration, double distance) {
    double paceSeconds = duration.inSeconds.toDouble() / (distance / 1000);
    int min = (paceSeconds / 60).floor();
    int sec = (paceSeconds % 60).round();
    return "$min:${sec.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () { Navigator.pushNamed(context, RunDataDetailScreen.routeName, arguments: i); },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(top: 20, bottom: 20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 75,
                height: 75,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<FirestoreService>(builder: ((context, run, child) => Text((run.getDistance(i, true) / 1000).toStringAsFixed(1), style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 48, fontWeight: FontWeight.bold, height: 1)))),
                      const Text("km", style: TextStyle(color: Color(0xff6C757D), fontSize: 24, fontWeight: FontWeight.bold, height: 0.7)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18), //spacing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("${allRuns[i].duration.inHours}:${allRuns[i].duration.inMinutes.remainder(60)}:${allRuns[i].duration.inSeconds.remainder(60)}", style: TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Consumer<FirestoreService>(builder: ((context, run, child) => DurationAndPaceFormat(run.getDuration(i, true)))),
                      const SizedBox(width: 15), //spacing
                      SizedBox(
                        width: 60, height: 24,
                        child: FittedBox(
                          fit: BoxFit.none,
                          child:  Consumer<FirestoreService>(builder: ((context, run, child) => Text(calculatePace(run.getDuration(i, true), run.getDistance(i, true)).toString(), style: TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1))))
                        )
                      ),
                      const SizedBox(width: 3 ), //spacing
                      const Text("min/km", style: TextStyle(color: Color(0xff6C757D), fontSize: 10, fontWeight: FontWeight.bold, height: 2.5)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(allRuns[i].location, style: TextStyle(color: Color(0xff6C757D), fontSize: 18, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(DateFormat("EEEE, d MMM y, ").add_jm().format(allRuns[i].dateTime), style: TextStyle(color: Color(0xffADB5BD), fontSize: 12, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
        ],
      ),
    );
  }
}

class DurationAndPaceFormat extends StatelessWidget {
  Duration duration;
  DurationAndPaceFormat(this.duration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (duration.inHours > 0) ... [
          Text("${duration.inHours}", style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1)),
          const SizedBox(width: 3 ), //spacing
          const Text("hr", style: TextStyle(color: Color(0xff6C757D), fontSize: 10, fontWeight: FontWeight.bold, height: 2.5)),
          const SizedBox(width: 5),
          Text("${duration.inMinutes.remainder(60)}", style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1)),
          const SizedBox(width: 3 ), //spacing
          const Text("min", style: TextStyle(color: Color(0xff6C757D), fontSize: 10, fontWeight: FontWeight.bold, height: 2.5)),
        ] else if (duration.inMinutes <= 0)...[
          SizedBox(
            width: 30, height: 24,
            child: FittedBox(
              fit: BoxFit.none,
              child: Text(duration.inSeconds.toString().padLeft(2, "0"), style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1))
            )
          ),
          const SizedBox(width: 3 ), //spacing
          const Text("sec", style: TextStyle(color: Color(0xff6C757D), fontSize: 10, fontWeight: FontWeight.bold, height: 2.5)),
        ] else ...[
          SizedBox(
            width: 30, height: 24,
            child: FittedBox(
              fit: BoxFit.none,
              child: Text("${duration.inMinutes}", style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 24, fontWeight: FontWeight.bold, height: 1))
            )
          ),
          const SizedBox(width: 3 ), //spacing
          const Text("min", style: TextStyle(color: Color(0xff6C757D), fontSize: 10, fontWeight: FontWeight.bold, height: 2.5)),
        ]
      ],
    );
  }
}

