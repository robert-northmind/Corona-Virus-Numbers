import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/main.dart';
import 'package:corona_stats/widgets/details_page/weekly_day_to_day_summary_widget.dart';
import 'package:corona_stats/widgets/details_page/summary_list_tile.dart';
import 'package:flutter/material.dart';

class DetailsPageRoute extends StatelessWidget {
  final Covid19CountryReport countryReport;

  const DetailsPageRoute({Key key, this.countryReport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitleWidget(
          title: countryReport.country,
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SummaryListTileWidget(
              title: 'Total cases',
              values: countryReport.reports.reversed
                  .map(
                    (item) => item.confirmed,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Deaths',
              values: countryReport.reports.reversed
                  .map(
                    (item) => item.deaths,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Recovered',
              values: countryReport.reports.reversed
                  .map(
                    (item) => item.recovered,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Active cases',
              values: countryReport.reports.reversed
                  .map(
                    (item) => item.confirmed - item.recovered,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: "Death rate in %",
              values: countryReport.reports.reversed.map((item) {
                return item.deaths / item.confirmed.toDouble() * 100;
              }).toList(),
            ),
            WeeklyDayToDaySummaryWidget(
              key: Key('DayToDayListWidget'),
              countryReport: countryReport,
            )
          ],
        ),
      ),
    );
  }
}
