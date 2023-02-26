import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habittracker/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary(
      {Key? key, required this.datasets, required this.startDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(230, 171, 234, 255),
          2: Color.fromARGB(230, 171, 208, 255),
          3: Color.fromARGB(230, 171, 182, 255),
          4: Color.fromARGB(230, 171, 156, 255),
          5: Color.fromARGB(230, 171, 130, 255),
          6: Color.fromARGB(230, 171, 104, 255),
          7: Color.fromARGB(230, 152, 78, 255),
          8: Color.fromARGB(230, 130, 52, 255),
          9: Color.fromARGB(230, 110, 26, 255),
          10: Color.fromARGB(230, 91, 0, 255),
        },
      ),
    );
  }
}
