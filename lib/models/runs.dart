import 'package:ruunr/models/laps.dart';

class Runs {
  String location;
  DateTime dateTime;
  double distance;
  Duration duration;
  double meterPerLap;
  String note;
  List<Laps> laps;

  Runs({ required this.location, required this.dateTime, required this.distance, required this.duration, required this.meterPerLap, required this.note, required this.laps });
}