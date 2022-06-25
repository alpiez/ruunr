import 'dart:convert';

class Laps {
  int lap;
  String timing;
  String timingDifference;
  int seconds;

  Laps({required this.lap, required this.timing, required this.timingDifference, required this.seconds});


  // https://stackoverflow.com/questions/61316208/how-to-save-listobject-to-sharedpreferences-in-flutter
  factory Laps.fromJson(Map<String, dynamic> jsonData) {
    return Laps(
      lap: jsonData["lap"],
      timing: jsonData["timing"],
      timingDifference: jsonData["timingDifference"],
      seconds: jsonData["seconds"]
    );
  }

  static Map<String, dynamic> toMap(Laps laps) {
    return {
      "lap": laps.lap,
      "timing": laps.timing,
      "timingDifference": laps.timingDifference,
      "seconds": laps.seconds
    };
  }

  static String encode(List<Laps> laps) {
    return jsonEncode(laps.map<Map<String, dynamic>>((laps) => Laps.toMap(laps)).toList());
    // return jsonEncode(laps);
  }

  static List<Laps> decode(String lapString) {
    return (jsonDecode(lapString) as List<dynamic>).map((item) => Laps.fromJson(item)).toList();
  }
}