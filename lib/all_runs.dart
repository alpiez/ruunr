import 'package:flutter/cupertino.dart';
import 'package:ruunr/models/laps.dart';
import 'package:ruunr/models/runs.dart';

class AllRunsData extends ChangeNotifier{
  static List<Runs> allRuns = [
    Runs(location: "Bedok Reservoir", dateTime: DateTime(2020, 11, 1, 17, 11), distance: 3500, duration: const Duration(hours: 0, minutes: 19, seconds: 01), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:19:01", timingDifference: "00:03:46", seconds: 226),
      ]
    ),
    Runs(location: "Bedok Reservoir", dateTime: DateTime(2020, 12, 6, 16, 23), distance: 2800, duration: const Duration(hours: 0, minutes: 13, seconds: 29), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:11", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 2, timing: "00:06:22", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 3, timing: "00:10:06", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 4, timing: "00:13:29", timingDifference: "00:03:10", seconds: 190),
      ]
    ),
    Runs(location: "Bedok Reservoir", dateTime: DateTime(2020, 12, 28, 16, 31), distance: 8400, duration: const Duration(hours: 0, minutes: 44, seconds: 38), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:18:44", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 6, timing: "00:21:55", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 7, timing: "00:25:17", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 8, timing: "00:28:53", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 9, timing: "00:32:03", timingDifference: "00:03:10", seconds: 190),
        Laps(lap: 10, timing: "00:35:37", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 11, timing: "00:39:48", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 12, timing: "00:44:38", timingDifference: "00:04:23", seconds: 263),       
      ]
    ),
    Runs(location: "Tampines Hub", dateTime: DateTime(2021, 1, 6, 18, 23), distance: 3500, duration: const Duration(hours: 0, minutes: 19, seconds: 01), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:19:01", timingDifference: "00:03:46", seconds: 226),
      ]
    ),
    Runs(location: "Tampines Hub", dateTime: DateTime(2021, 2, 3, 18, 55), distance: 2800, duration: const Duration(hours: 0, minutes: 13, seconds: 29), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:11", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 2, timing: "00:06:22", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 3, timing: "00:10:06", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 4, timing: "00:13:29", timingDifference: "00:03:10", seconds: 190),
      ]
    ),
    Runs(location: "Tampines Hub", dateTime: DateTime(2021, 2, 23, 16, 23), distance: 8400, duration: const Duration(hours: 0, minutes: 44, seconds: 38), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:18:44", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 6, timing: "00:21:55", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 7, timing: "00:25:17", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 8, timing: "00:28:53", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 9, timing: "00:32:03", timingDifference: "00:03:10", seconds: 190),
        Laps(lap: 10, timing: "00:35:37", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 11, timing: "00:39:48", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 12, timing: "00:44:38", timingDifference: "00:04:23", seconds: 263),       
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2021, 3, 20, 18, 03), distance: 3500, duration: const Duration(hours: 0, minutes: 19, seconds: 01), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:19:01", timingDifference: "00:03:46", seconds: 226),
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2022, 4, 10, 18, 03), distance: 2800, duration: const Duration(hours: 0, minutes: 13, seconds: 29), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:11", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 2, timing: "00:06:22", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 3, timing: "00:10:06", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 4, timing: "00:13:29", timingDifference: "00:03:10", seconds: 190),
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2022, 5, 1, 12, 11), distance: 8400, duration: const Duration(hours: 0, minutes: 44, seconds: 38), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:18:44", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 6, timing: "00:21:55", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 7, timing: "00:25:17", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 8, timing: "00:28:53", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 9, timing: "00:32:03", timingDifference: "00:03:10", seconds: 190),
        Laps(lap: 10, timing: "00:35:37", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 11, timing: "00:39:48", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 12, timing: "00:44:38", timingDifference: "00:04:23", seconds: 263),       
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2022, 7, 2, 18, 03), distance: 3500, duration: const Duration(hours: 0, minutes: 19, seconds: 01), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:19:01", timingDifference: "00:03:46", seconds: 226),
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2022, 7, 15, 18, 03), distance: 2800, duration: const Duration(hours: 0, minutes: 13, seconds: 29), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:11", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 2, timing: "00:06:22", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 3, timing: "00:10:06", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 4, timing: "00:13:29", timingDifference: "00:03:10", seconds: 190),
      ]
    ),
    Runs(location: "Outside House", dateTime: DateTime(2022, 7, 20, 12, 11), distance: 8400, duration: const Duration(hours: 0, minutes: 44, seconds: 38), meterPerLap: 700, note: "",
      laps: [
        Laps(lap: 1, timing: "00:03:07", timingDifference: "00:03:07", seconds: 187),
        Laps(lap: 2, timing: "00:06:25", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 3, timing: "00:10:36", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 4, timing: "00:14:58", timingDifference: "00:04:23", seconds: 263),
        Laps(lap: 5, timing: "00:18:44", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 6, timing: "00:21:55", timingDifference: "00:03:11", seconds: 191),
        Laps(lap: 7, timing: "00:25:17", timingDifference: "00:03:22", seconds: 202),
        Laps(lap: 8, timing: "00:28:53", timingDifference: "00:03:46", seconds: 226),
        Laps(lap: 9, timing: "00:32:03", timingDifference: "00:03:10", seconds: 190),
        Laps(lap: 10, timing: "00:35:37", timingDifference: "00:03:34", seconds: 214),
        Laps(lap: 11, timing: "00:39:48", timingDifference: "00:04:11", seconds: 251),
        Laps(lap: 12, timing: "00:44:38", timingDifference: "00:04:23", seconds: 263),       
      ]
    ),
  ];

  void add(Runs run) {
    allRuns.add(run);
    notifyListeners();
  }

  void edit(Runs run, int i){
    allRuns[i] = run;
    notifyListeners();
  }

  void delete(int i) {
    allRuns.removeAt(i);
    notifyListeners();
  }

  double getDistance(int i, bool reversed) {
    if (reversed == true) {
      return allRuns.reversed.toList()[i].distance;
    }
    return allRuns[i].distance;
  }

  List<Runs> getMonthlyDistance(DateTime datetime) {
    List<Runs> months = [];
    for (var i in allRuns) {
      if (i.dateTime.month == datetime.month && i.dateTime.year == datetime.year){
        months.add(i);
      }
    }
    print(months);
    return months;
  }
  
  Duration getDuration(int i, bool reversed) {
    if (reversed == true) {
      return allRuns.reversed.toList()[i].duration;
    }
    return allRuns[i].duration;
  }

}