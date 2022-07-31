import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/services/firestore_service.dart';
import 'package:ruunr/widgets/runs_data_listview.dart';

class RunsScreen extends StatefulWidget {
  static String routeName = '/runs';
  
  const RunsScreen({ Key? key }) : super(key: key);

  @override
  State<RunsScreen> createState() => _RunsScreenState();
}

class _RunsScreenState extends State<RunsScreen> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<Runs> allRuns = FirestoreService.allRuns;

    return Scaffold(
      appBar: AppBar(title: const Text("All Runs")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          RunDataListview(allRuns)
        ]
      )
    );
  }
}