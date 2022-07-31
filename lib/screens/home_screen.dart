import 'package:flutter/material.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/main.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/screens/runs_all_screen.dart';
import 'package:ruunr/services/firestore_service.dart';
import 'package:ruunr/widgets/monthly_mini_widget.dart';
import 'package:ruunr/widgets/runs_data_listview.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  List<Runs> allRuns = FirestoreService.allRuns;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Runs"),),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Activities", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
              const MiniMonthlyWidget(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => { print("idk man") },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("View more activities", style: TextStyle(color: Color(0xffADB5BD))),
                    Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
                  ],
                ),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: Size(double.infinity,54), primary: Color(0xff343A40)),
              ),
              const SizedBox(height: 50),
              const Text("Recent Runs", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
              RunDataListview(allRuns, listsLimit: 5),
              ElevatedButton(
                onPressed: () => { Navigator.pushNamed(context, RunsScreen.routeName) },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("View more runs", style: TextStyle(color: Color(0xffADB5BD))),
                    Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
                  ],
                ),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: Size(double.infinity,54), primary: Color(0xff343A40)),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ]
      ),
    );
  }
}
