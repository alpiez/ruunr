import 'package:flutter/widgets.dart';

class MeasurementColumn extends StatelessWidget {
  final String measurement;
  final String number;
  final String unit;
  final double? mainSize;
  const MeasurementColumn(this.measurement, this.number, this.unit, { this.mainSize = 67, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(measurement, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.normal, color: Color(0xffADB5BD))),
        Text(number, style: TextStyle(fontSize: mainSize, fontWeight: FontWeight.w700, color: const Color(0xffF8F9FA), height: 1)),
        Text(unit, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xff6C757D), height: 0.7)),
      ],
    );
  }
}