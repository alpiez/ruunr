import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ruunr/models/laps.dart';
import 'package:ruunr/models/runs.dart';

class FirestoreService extends ChangeNotifier{
  static List<Runs> allRuns = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Runs>> getRuns() {
    return FirebaseFirestore.instance.collection("users").doc(uid).collection("runs").orderBy("dateTime", descending: true).snapshots().map((value) {
      List<Runs> R = [];
      String location;
      DateTime dateTime;
      String distance;
      Duration duration;
      String meterPerLap;
      String note;
      List<Laps> laps;
      for (var i in value.docs){
        // print(i.data());
        location = i.get("location");
        dateTime = formatDateTime(i.get("dateTime"));
        distance = i.get("distance").toString();
        duration = formatDuration(i.get("duration"));
        meterPerLap = i.get("meterPerLap").toString();
        note = i.get("note");
        laps = Laps.decode(i.get("laps"));
        R.add(Runs(location: location, dateTime: dateTime, distance: double.parse(distance), duration: duration, meterPerLap: double.parse(meterPerLap), note: note, laps: laps));
      }
      allRuns = R;
      return R;
    });
  }
  
  addRun(Runs run) {
    DateTime now = DateTime.now();
    FirebaseFirestore.instance.collection("users").doc(uid).collection("runs").doc(DateFormat("y-MM-dd").add_Hm().format(now)).set({
      "location": run.location, 
      "dateTime": DateFormat("y/MM/dd").add_Hm().format(now), 
      "distance": run.distance, 
      "duration": run.duration.inSeconds, 
      "meterPerLap": run.meterPerLap, 
      "note": run.note, 
      "laps": Laps.encode(run.laps)
    });
  }

  updateRun(DateTime dateTime, Runs run) {
    String docRef() => DateFormat("y-MM-dd").add_Hm().format(dateTime);
    FirebaseFirestore.instance.collection("users/"+uid+"/runs").doc(docRef()).update({
      "location": run.location, 
      "dateTime": DateFormat("y/MM/dd").add_Hm().format(dateTime), 
      "distance": run.distance, 
      "duration": run.duration.inSeconds, 
      "meterPerLap": run.meterPerLap, 
      "note": run.note, 
      "laps": Laps.encode(run.laps)
    });
  }

  void edit(Runs run, int i){
    allRuns[i] = run;
    notifyListeners();
  }

  deleteRun(DateTime dateTime) {
    String docRef() => DateFormat("y-MM-dd").add_Hm().format(dateTime);
    FirebaseFirestore.instance.collection("users/"+uid+"/runs").doc(docRef()).delete();
  }

  DateTime formatDateTime(String dateTime) {
    int day;
    int month;
    int year;
    int hour;
    int minute;
    year = int.parse(dateTime[0]+dateTime[1]+dateTime[2]+dateTime[3]);
    month = int.parse(dateTime[5]+dateTime[6]);
    day = int.parse(dateTime[8]+dateTime[9]);
    hour = int.parse(dateTime[11]+dateTime[12]);
    minute = int.parse(dateTime[14]+dateTime[15]);
    return DateTime(year, month, day, hour, minute);
  }

  Duration formatDuration(int duration) {
    return Duration(seconds: duration);
  }

  double getDistance(int i, bool reversed) {
    if (allRuns.isEmpty) {
      return 0;
    }
    if (reversed == true) {
      return allRuns.toList()[i].distance;
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
    return months;
  }

  Duration getDuration(int i, bool reversed) {
    if (allRuns.isEmpty) {
      return Duration.zero;
    }
    if (reversed == true) {
      return allRuns.toList()[i].duration;
    }
    return allRuns[i].duration;
  }
}