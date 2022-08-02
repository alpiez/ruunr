import 'package:flutter/material.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/widgets/runs_data_mini_widget.dart';

class RunDataListview extends StatelessWidget {
  final List<Runs> allRuns;
  final int listsLimit;
  const RunDataListview(this.allRuns, { this.listsLimit = -1, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (allRuns.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Column(
            children: const[
              Text("Empty,", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xff6C757D))),
              Text("why not start running?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xff6C757D)))
            ],
          ),
        )
      );
    } else {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return MiniRunDataWidget(allRuns.toList(), i); //just change back to "allRuns" if don't want reverse list.
        },
        itemCount: (listsLimit == -1) ? allRuns.length : listsLimit>=allRuns.length ? allRuns.length : listsLimit ,
        separatorBuilder: (ctx, i) {
          return const Divider(height: 3, color: Color(0xff343A40), thickness: 1.5,);
        },
      );
    }
  }
}
