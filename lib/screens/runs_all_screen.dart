import 'package:flutter/material.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/widgets/runs_data_listview.dart';

class RunsScreen extends StatelessWidget {
  static String routeName = '/runs';
  
  const RunsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Runs> allRuns = AllRunsData.allRuns;

    return Scaffold(
      appBar: AppBar(title: Text("All Runs")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          RunDataListview(allRuns)
        ]
      ),
    );
  }
}