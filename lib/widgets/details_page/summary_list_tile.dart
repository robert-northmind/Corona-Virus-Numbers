import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryListTileWidget extends StatelessWidget {
  final String title;
  final List<num> values;

  const SummaryListTileWidget({
    Key key,
    this.title,
    this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        numberFormatter.format(
                          values[values.length - 1],
                        ),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 16, color: Colors.black38),
                      )
                    ]),
              ),
            ),
            Expanded(
                flex: 6,
                child: LineChart(
                  lines: [
                    Sparkline(
                      data: values.map((data) => data.toDouble()).toList(),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
