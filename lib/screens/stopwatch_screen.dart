import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/laps.dart';
import 'package:ruunr/screens/stopwatch_save_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchScreen extends StatefulWidget {
  static String routeName = "/stopwatch";
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  SharedPreferences? prefs;
  Timer? timer;
  bool started = false;
  List<Laps> laps = [];
  List<Laps> lapsReversed = [];
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  String timing = "00:00:00";
  
  int diffHours = 0;
  int diffMinutes = 0;
  int diffSeconds = 0;

  @override
  void initState() {
    super.initState();
    loadSharedPref();
  }

  Future<void> loadSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs!.containsKey("laps")){
      laps = Laps.decode(prefs!.getString("laps")!);
      setState(() {
        lapsReversed = laps.reversed.toList();
        hours = prefs!.getInt("hours")!;
        minutes = prefs!.getInt("minutes")!;
        seconds = prefs!.getInt("seconds")!;
      });
    }
  }

  savePrefs() {
    prefs!.setInt("hours", hours);
    prefs!.setInt("minutes", minutes);
    prefs!.setInt("seconds", seconds);
    prefs!.setString("laps", Laps.encode(laps));
  }
  
  void startTimer() {
    setState(() {
      started = true;
    });

    int _hours = hours;
    int _minutes = minutes;
    int _seconds = seconds;
    int _milliseconds = milliseconds;

    timer = Timer.periodic(
      const Duration(milliseconds: 37), //999 = 37 * 27
      (timer) { 
        // print(timer.tick);
        if (milliseconds == 999) {
          if (seconds == 59) {
            if (minutes == 59) {
              _hours++;
              _minutes = 0;
              _seconds = 0;
              _milliseconds = 0;
            } else {
              _minutes++;
              _seconds = 0;
              _milliseconds = 0;
            }
          } else {
            _seconds++;
            _milliseconds = 0;
          }

          // This condition's placement gonna be weird in terms of timing accuracy.
          if (diffSeconds == 59) {
            if (diffMinutes == 59) {
              diffHours++;
              diffMinutes = 0;
              diffSeconds = 0;
            } else {
              diffMinutes++;
              diffSeconds = 0;
            }
          } else {
            diffSeconds++;
          }

        } else {
          _milliseconds += 37;
        }
        setState(() {
          hours = _hours;
          minutes = _minutes;
          seconds = _seconds;
          milliseconds = _milliseconds;
        });
        // print("$milliseconds ${timer.tick}");
        // print("${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}");
      }
    );
  }

  void stopTimer() {
    setState(() {
      started = false;
    });
    timer?.cancel();
    if (laps.isEmpty) {
      lapRun();
    }
    savePrefs();
  }

  void resetTimer() {
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      milliseconds = 0;
    });
    diffHours = 0;
    diffMinutes = 0;
    diffSeconds = 0;
    laps.clear();
    lapsReversed.clear();
    prefs!.remove("laps");
  }

  String timingFormat(int hours, int minutes, int seconds) {
    timing = "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
    return(timing);
  }

  lapRun() {
    int totalSeconds = ((diffHours * 60 * 60) + (diffMinutes * 60) + diffSeconds);
    laps.add(Laps(lap: laps.length+1, timing: timing, timingDifference: timingFormat(diffHours, diffMinutes, diffSeconds), seconds: totalSeconds));
    diffHours = 0;
    diffMinutes = 0;
    diffSeconds = 0;
    lapsReversed = laps.reversed.toList();
    // print(laps);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stopwatch")),
      body: Center(
        child: Column(
          children: [
            Text(timingFormat(hours, minutes, seconds), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 68, color: Color(0xffF8F9FA), height: 2)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 50, right: 50),
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                      
                      children: [
                        Text("Lap " + (lapsReversed.length - i).toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xffADB5BD), fontSize: 20)),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lapsReversed!=[] ? lapsReversed[i].timingDifference : "null", style: const TextStyle(color: Color(0xffF8F9FA), fontSize: 17)),
                              Text(lapsReversed!=[] ? lapsReversed[i].timing : "null", style: const TextStyle(color: Color(0xff6C757D), fontSize: 12)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }, 
                separatorBuilder: (ctx, i) {
                  return const Divider(height: 3, color: Color(0xff343A40), thickness: 1.5,);
                }, 
                itemCount: lapsReversed.length,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () { (!started) ? resetTimer() : lapRun(); },
                  child: Container(child: Text((!started) ? "Reset" : "Lap", style: const TextStyle(color: Color(0xffDEE2E6), fontWeight: FontWeight.w500, fontSize: 18)), width: 60, height: 60, alignment: Alignment.center),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff212529),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: const BorderSide(width: 3, color: Color(0xffDEE2E6)),
                    ),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero
                  ), 
                ),
                ElevatedButton(
                  onPressed: () { (!started) ? startTimer() : stopTimer(); },
                  child: Container(child: (!started) ? const Text("Start", style: TextStyle(color: Color(0xff212529), fontWeight: FontWeight.w500, fontSize: 18)) : const Icon(Icons.pause), width: 60, height: 60, alignment: Alignment.center),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffF8F9FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    padding: const EdgeInsets.all(10)
                  ), 
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: (!started) ? (laps.isNotEmpty) ?
                  ElevatedButton(
                    onPressed: () { Navigator.pushNamed(context, SaveStopwatchScreen.routeName, arguments: laps); savePrefs(); },
                    child: Container(child: const Text("Save", style: TextStyle(color: Color(0xffDEE2E6), fontWeight: FontWeight.w500, fontSize: 18)), width: 60, height: 60, alignment: Alignment.center),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff212529),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(width: 3, color: Color(0xffDEE2E6)),
                      ),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero
                    ), 
                  ) : const SizedBox(width: 60) : const SizedBox(width: 60),
                )
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}