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
              values: countryReport.allReports
                  .map(
                    (item) => item.confirmed,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Deaths',
              values: countryReport.allReports
                  .map(
                    (item) => item.deaths,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Recovered',
              values: countryReport.allReports
                  .map(
                    (item) => item.recovered,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: 'Active cases',
              values: countryReport.allReports
                  .map(
                    (item) => item.confirmed - item.recovered,
                  )
                  .toList(),
            ),
            SummaryListTileWidget(
              title: "Death rate in %",
              values: countryReport.allReports.map((item) {
                if (item.confirmed <= 0) {
                  return 0;
                } else {
                  return item.deaths / item.confirmed.toDouble() * 100;
                }
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
