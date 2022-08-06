import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ruunr/services/firestore_service.dart';

class MiniChartWidget extends StatefulWidget {
  const MiniChartWidget({ Key? key }) : super(key: key);

  @override
  State<MiniChartWidget> createState() => _MiniChartWidgetState();
}

class _MiniChartWidgetState extends State<MiniChartWidget> {
  List<double> monthlyTotalDistance = [];
  
  BarChartGroupData createGrpData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)), width: 16, color: const Color(0xffCED4DA))
      ],
      barsSpace: 5
    );
  }

  // Collect every from allRuns and sort them into month with current year.
  double getTotalDistance(int index) {
    DateTime now = DateTime.now();
    double jan = 0;
    double feb = 0;
    double mar = 0;
    double apr = 0;
    double may = 0;
    double jun = 0;
    double jul = 0;
    double aug = 0;
    double sep = 0;
    double oct = 0;
    double nov = 0;
    double dec = 0;
    for (var i in FirestoreService.allRuns) {
      for (var month=1; month<=12; month++) {
        if (i.dateTime.month == month && i.dateTime.year == now.year) {
          switch (month) {
            case 1 : jan += i.distance; break;
            case 2 : feb += i.distance; break;
            case 3 : mar += i.distance; break;
            case 4 : apr += i.distance; break;
            case 5 : may += i.distance; break;
            case 6 : jun += i.distance; break;
            case 7 : jul += i.distance; break;
            case 8 : aug += i.distance; break;
            case 9 : sep += i.distance; break;
            case 10: oct += i.distance; break;
            case 11: nov += i.distance; break;
            case 12: dec += i.distance; break;
          }
        }
      }
      // if (i.dateTime.month == DateTime.january && i.dateTime.year == now.year) {
      //   jan += i.distance;
      // } else if (i.dateTime.month == DateTime.february && i.dateTime.year == now.year) {
      //   feb += i.distance;
      // } else if (i.dateTime.month == DateTime.march && i.dateTime.year == now.year) {
      //   mar += i.distance;
      // } else if (i.dateTime.month == DateTime.april && i.dateTime.year == now.year) {
      //   apr += i.distance;
      // } else if (i.dateTime.month == DateTime.may && i.dateTime.year == now.year) {
      //   may += i.distance;
      // } else if (i.dateTime.month == DateTime.june && i.dateTime.year == now.year) {
      //   jun += i.distance;
      // } else if (i.dateTime.month == DateTime.july && i.dateTime.year == now.year) {
      //   jul += i.distance;
      // } else if (i.dateTime.month == DateTime.august && i.dateTime.year == now.year) {
      //   aug += i.distance;
      // } else if (i.dateTime.month == DateTime.september && i.dateTime.year == now.year) {
      //   sep += i.distance;
      // } else if (i.dateTime.month == DateTime.october && i.dateTime.year == now.year) {
      //   oct += i.distance;
      // } else if (i.dateTime.month == DateTime.november && i.dateTime.year == now.year) {
      //   nov += i.distance;
      // } else if (i.dateTime.month == DateTime.december && i.dateTime.year == now.year) {
      //   dec += i.distance;
      // }
    }
    double chosen = 0;
    switch (index) {
      case 1:  chosen = jan/1000; break;
      case 2:  chosen = feb/1000; break;
      case 3:  chosen = mar/1000; break;
      case 4:  chosen = apr/1000; break;
      case 5:  chosen = may/1000; break;
      case 6:  chosen = jun/1000; break;
      case 7:  chosen = jul/1000; break;
      case 8:  chosen = aug/1000; break;
      case 9:  chosen = sep/1000; break;
      case 10: chosen = oct/1000; break;
      case 11: chosen = nov/1000; break;
      case 12: chosen = dec/1000; break;
    }
    return chosen;
  }
  
  List<BarChartGroupData> allData() => [
    createGrpData(1,  getTotalDistance(1)),
    createGrpData(2,  getTotalDistance(2)),
    createGrpData(3,  getTotalDistance(3)),
    createGrpData(4,  getTotalDistance(4)),
    createGrpData(5,  getTotalDistance(5)),
    createGrpData(6,  getTotalDistance(6)),
    createGrpData(7,  getTotalDistance(7)),
    createGrpData(8,  getTotalDistance(8)),
    createGrpData(9,  getTotalDistance(9)),
    createGrpData(10, getTotalDistance(10)),
    createGrpData(11, getTotalDistance(11)),
    createGrpData(12, getTotalDistance(12)),
  ];

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xffCED4DA), fontWeight: FontWeight.bold, fontSize: 10);
    Widget text;
    switch (value.toInt()) {
      case 1 : text = const Text('Jan', style: style); break;
      case 2 : text = const Text('Feb', style: style); break;
      case 3 : text = const Text('Mar', style: style); break;
      case 4 : text = const Text('Apr', style: style); break;
      case 5 : text = const Text('May', style: style); break;
      case 6 : text = const Text('Jun', style: style); break;
      case 7 : text = const Text('Jul', style: style); break;
      case 8 : text = const Text('Aug', style: style); break;
      case 9 : text = const Text('Sep', style: style); break;
      case 10: text = const Text('Oct', style: style); break;
      case 11: text = const Text('Nov', style: style); break;
      case 12: text = const Text('Dec', style: style); break;
      default: text = const Text(''   , style: style); break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: BarChart(
        BarChartData(
          barGroups: allData(),
          borderData: FlBorderData(show: false),
          alignment: BarChartAlignment.center,
          groupsSpace: 12,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true, 
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles, reservedSize: 38)),
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150), // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }
}