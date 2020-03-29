import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final Covid19CountryReport countryReport;
  SimpleLineChart({this.countryReport});

  @override
  Widget build(BuildContext context) {
    final verticalPadding =
        5 + 40 * countryReport.lineGraphVerticalPaddingFactor();
    final data = countryReport.getLineGraphData();

    return Container(
      child: AspectRatio(
        aspectRatio: 2.1,
        child: LineChart(
          chartPadding:
              EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 20),
          lines: [
            new Sparkline(
              data: data,
              stroke: new PaintOptions.stroke(
                color: Colors.red[500],
                strokeWidth: 3.0,
              ),
              marker: new MarkerOptions(
                size: 4.0,
                paint: new PaintOptions.fill(color: Colors.red[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final Covid19CountryReport countryReport;
  SimpleBarChart({this.countryReport});

  @override
  Widget build(BuildContext context) {
    final charReports = countryReport.barChartGtraphReports();

    final xAxis = ChartAxis<int>(
      span: ListSpan(charReports.map((report) => report.index).toList()),
    );

    final yAxis = ChartAxis<int>(
      span: IntSpan(0, countryReport.getBarChartMaxValue()),
      tickGenerator: IntervalTickGenerator.byN(15),
    );

    final barStack1 = BarStack<int>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: BarChart<BarChartData, int, int>(
          data: charReports,
          xAxis: xAxis,
          yAxis: yAxis,
          bars: [
            Bar<BarChartData, int, int>(
              xFn: (reports) => reports.index,
              valueFn: (reports) => reports.value,
              fill: PaintOptions.fill(color: Colors.amber),
              stack: barStack1,
            ),
          ],
        ),
      ),
    );
  }
}
