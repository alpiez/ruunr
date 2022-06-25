import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/laps.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/screens/runs_edit_screen.dart';
import 'package:ruunr/widgets/measurement_column.dart';

class RunDataDetailScreen extends StatelessWidget {
  static String routeName = "/run-detail";

  const RunDataDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    Runs runs = AllRunsData.allRuns.reversed.toList()[index];
    List<Laps> lapsReversed = runs.laps.reversed.toList();
    int indexToBeReplaced = AllRunsData.allRuns.indexWhere((element) => element.dateTime == runs.dateTime);


    String calculatePace(Duration duration, double distance) {
      double paceSeconds = duration.inSeconds.toDouble() / (distance / 1000);
      int min = (paceSeconds / 60).floor();
      int sec = (paceSeconds % 60).round();
      return "$min:${sec.toString().padLeft(2, "0")}";
    }

    confirmDelete() {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff343A40),
            title: const Text("Confirm Delete?"),
            actions: [
              TextButton(onPressed: () {Provider.of<AllRunsData>(context, listen: false).delete(indexToBeReplaced); Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);}, child: const Text("Yes")),
              TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("No"))
            ],
          );
        }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat("EEEE").format(runs.dateTime), style: const TextStyle(fontSize: 24)),
            Text(DateFormat("d MMM y").format(runs.dateTime), style: const TextStyle(fontSize: 24, height: 1)),
          ],
        ),
        // actions: [ IconButton(onPressed: (){ Navigator.pushNamed(context, EditRunsScreen.routeName, arguments: index);}, icon: Icon(Icons.more_horiz), iconSize: 36, splashRadius: 24)],
        actions: [
          PopupMenuButton(
            color: Color(0xff343A40),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Edit"), value: 0),
              PopupMenuItem(child: Text("Delete"), value: 1)
            ],
            onSelected: (result){
              switch (result) {
                case 0:
                  Navigator.pushNamed(context, EditRunsScreen.routeName, arguments: index);
                  break;
                case 1:
                  confirmDelete();
                  break;
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          Container(
            height: 240,
            alignment: Alignment.center,
            child: const Text("Map here lol"),
            decoration: const BoxDecoration(color: Color(0xff343A40)),
          ),
          const SizedBox(height: 50),
          const Text("Analysis", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
          Consumer<AllRunsData>( //This is from Provider
            builder: ((context, run, child) => 
              Wrap(
                spacing: 30,
                runSpacing: 30,
                children: [
                  MeasurementColumn("Total km", (run.getDistance(indexToBeReplaced, false) / 1000).toString(), "km"),
                  MeasurementColumn("Avg Pace", calculatePace(run.getDuration(indexToBeReplaced, false), run.getDistance(indexToBeReplaced, false)), "min/km"),
                  // MeasurementColumn("Calories", "208", "kcal"),
                ],
              )
            ),
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
            itemCount: runs.laps.length,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}