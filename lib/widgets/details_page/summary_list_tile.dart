import 'package:corona_stats/utils/theme.dart';
import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryListTileWidget extends StatelessWidget {
  final String title;
  final List<num> values;
  final bool isPercent;

  const SummaryListTileWidget(
      {Key key, this.title, this.values, this.isPercent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat();
    return Card(
      color: Covid19Theme.appBackgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                        (isPercent
                            ? '${values[values.length - 1].toStringAsFixed(1)} %'
                            : numberFormatter.format(
                                values[values.length - 1],
                              )),
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      Text(
                        title,
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
                      stroke: PaintOptions.stroke(
                        color: Colors.red[500],
                        strokeWidth: 2.0,
                      ),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
