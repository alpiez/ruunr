import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/laps.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/services/firestore_service.dart';
import 'package:ruunr/widgets/measurement_column.dart';

class EditRunsScreen extends StatefulWidget {
  static String routeName = "/edit-run";

  const EditRunsScreen({ Key? key }) : super(key: key);

  @override
  State<EditRunsScreen> createState() => _EditRunsScreenState();
}

class _EditRunsScreenState extends State<EditRunsScreen> {
  final editFormKey = GlobalKey<FormState>();
  DateTime date = DateTime(0);
  double meterPerLap = 0;
  double totalKm = 0;
  double totalMeter = 0;
  String loc = "";
  String note = "";
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  List<Runs> allRuns = FirestoreService.allRuns;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    Runs run = allRuns[index];
    List<Laps> laps = run.laps;
    List<Laps> lapsReversed = laps.reversed.toList();
    String docRef() => DateFormat("dd-MM-y").add_Hm().format(run.dateTime);
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (meterPerLap == 0 && totalKm == 0 && date == DateTime(0) && note.isEmpty) {
      // Condition set here to prevent setState reassigning below's variables due 
      // to nature of setState refreshing build() to update state. 
      meterPerLap = run.meterPerLap;
      totalKm = run.distance / 1000;
      date = run.dateTime;
      note = run.note;
    }
    int indexToBeReplaced = AllRunsData.allRuns.indexWhere((element) => element.dateTime == date);

    void getHoursMinutesSeconds(int totalSeconds) {
      seconds = (totalSeconds % 60);
      minutes = (totalSeconds / 60).floor();
      hours = (minutes / 60).floor();
    }

    int totalSeconds() {
      int n = 0;
      for (var i=0; i<laps.length; i++) { 
        n += laps[i].seconds;
      }
      getHoursMinutesSeconds(n);
      return n;
    }

    void calculateDistance() {
      totalMeter = meterPerLap * laps.length;
      totalKm = totalMeter / 1000;
    }

    String calculatePace(int totalSeconds, double distance) {
      double paceSeconds = (totalSeconds / distance); 
      int min = (paceSeconds / 60).floor();
      int sec = (paceSeconds % 60).round();
      return "$min:${sec.toString().padLeft(2, "0")}";
    }
    
    void validateForm() {
      editFormKey.currentState!.validate();
    }

    void saveForm() {
      bool isValid = editFormKey.currentState!.validate();

      if (isValid) {
        editFormKey.currentState!.save();
        // AllRunsData.allRuns[indexToBeReplaced] = (Runs(location: loc, dateTime: date, distance: totalMeter, duration: Duration(hours: hours, minutes: minutes, seconds: seconds), meterPerLap: meterPerLap, note: note, laps: laps));
        FirestoreService().updateRun(run.dateTime, Runs(location: loc, dateTime: date, distance: totalMeter, duration: Duration(hours: hours, minutes: minutes, seconds: seconds), meterPerLap: meterPerLap, note: note, laps: laps));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Run edited!")));
      }
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Run"), titleTextStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, fontFamily: "Poppins", color: Color(0xff6C757D))),
      body: GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); validateForm(); },
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat("d MMMM").format(date), style: const TextStyle(color: Color(0xffADB5BD), fontWeight: FontWeight.w700, fontSize: 42, height: 1)),
                      Text(DateFormat("y, EEEE").format(date), style: const TextStyle(color: Color(0xffADB5BD), fontWeight: FontWeight.w600, fontSize: 24, height: 0.7)),
                    ],
                  )
                ),
                const SizedBox(height: 30),
                Form(
                  key: editFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 32,
                        textInputAction: TextInputAction.next,
                        initialValue: run.location,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Location",
                          isDense: true,
                          prefixIcon: Icon(Icons.pin_drop, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value == ""){
                            return "Cannot leave this empty!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          loc = value as String;
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        maxLength: 8,
                        textInputAction: TextInputAction.next,
                        initialValue: run.meterPerLap.toString(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter meter per lap",
                          isDense: true,
                          prefixIcon: Icon(Icons.run_circle_outlined, size: 24),
                          suffix: Text("m")
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Cannot leave this empty!";
                          } else if (double.tryParse(value)==null) {
                            return "Invalid input";
                          } else {
                            setState(() {
                              meterPerLap = double.parse(value);
                              calculateDistance();
                            });
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value == null || value == "" || double.tryParse(value)==null) {
                            setState(() {
                              meterPerLap = 0;
                            });
                          } else {
                            setState(() {
                              meterPerLap = double.parse(value);
                            });
                            calculateDistance();
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        minLines: 1,
                        maxLines: 8,
                        initialValue: note,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Other Notes",
                          isDense: true,
                          prefixIcon: Icon(Icons.edit_note, size: 24),
                        ),
                        onSaved: (value) {
                          if (value!.trim().isNotEmpty) {
                            note = value.trim();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text("Analysis", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
                (meterPerLap==0)?Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xffCED4DA),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text("Not seeing any calculation? Fill in the information above.", style: TextStyle(fontSize: 14, color: Color(0xff343A40)))
                ): const SizedBox(),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  children: [
                    MeasurementColumn("Total km", (meterPerLap!=0) ? totalKm.toString():"-", "km"),
                    MeasurementColumn("Avg", (meterPerLap!=0)?(calculatePace(totalSeconds(), totalKm)):"-", "min/km"),
                    // MeasurementColumn("Calories", "208", "kcal"),
                  ],
                ),
                const SizedBox(height: 50),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
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
                  itemCount: laps.length,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveForm();
        },
        child: const Text("Save"),
      ),
    );
  }
}