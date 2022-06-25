import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruunr/widgets/measurement_column.dart';

class MiniMonthlyWidget extends StatelessWidget {
  const MiniMonthlyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { print("hi you just clicked this dingus"); },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(24, 16, 8, 16),
        primary: const Color(0xff343A40),
        // onPrimary: Color(0xffADB5BD), //this is for button effect thingy, uncomment if u wanna modify effect's color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        )
      ),
      child: Row( //Contains Texts and just a keyboard_arrow_right
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("This Month:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff6C757D))),
              Row(
                children: [
                  MeasurementColumn("Total km", "54", "km"),
                  const SizedBox(width: 30),
                  MeasurementColumn("Avg Pace", "6.2", "min/km"),
                ],
              )
            ],
          ),
          const Icon(Icons.keyboard_arrow_right, color: Color(0xffDEE2E6))
        ],
      ),
    );
  }
}
