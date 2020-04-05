import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyDayToDaySummaryWidget extends StatelessWidget {
  final List<_DayToDayListItem> _list = [];

  WeeklyDayToDaySummaryWidget({
    Key key,
    Covid19CountryReport countryReport,
  }) : super(key: key) {
    final reversed = countryReport.reports.reversed.toList();
    for (var i = 1; i < reversed.length; i++) {
      final currentDay = reversed[i];
      final previousDay = reversed[i - 1];
      final hasChanged = currentDay.deaths != previousDay.deaths ||
          currentDay.confirmed != previousDay.confirmed ||
          currentDay.recovered != previousDay.recovered;
      if (hasChanged) {
        _list.add(_DayToDayListItem(
          date: currentDay.date,
          deaths: _DailyStat(
            current: currentDay.deaths,
            previous: previousDay.deaths,
          ),
          newCases: _DailyStat(
            current: currentDay.confirmed,
            previous: previousDay.confirmed,
          ),
          recovered: _DailyStat(
            current: currentDay.recovered,
            previous: previousDay.recovered,
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("dd. MMMM. yyyy");
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Last ${_list.length} days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list.reversed.toList()[index];
                return SizedBox(
                  height: 70,
                  child: Container(
                    child: ListTile(
                        title: Text(
                          formatter.format(item.date),
                        ),
                        subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _StatsItemWidget(
                                title: 'New cases',
                                value: item.newCases,
                                positiveIncrement: Colors.greenAccent,
                                negativeIncrement: Colors.redAccent,
                              ),
                              _StatsItemWidget(
                                title: 'Recovered',
                                value: item.recovered,
                                positiveIncrement: Colors.greenAccent,
                                negativeIncrement: Colors.redAccent,
                              ),
                              _StatsItemWidget(
                                title: 'Deaths',
                                value: item.deaths,
                                positiveIncrement: Colors.greenAccent,
                                negativeIncrement: Colors.redAccent,
                              ),
                            ])),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _StatsItemWidget extends StatelessWidget {
  final String title;
  final Color positiveIncrement;
  final Color negativeIncrement;
  final _DailyStat value;

  const _StatsItemWidget({
    Key key,
    this.title,
    this.positiveIncrement,
    this.negativeIncrement,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("$title: "),
      Text("${value.current - value.previous}"),
    ]);
  }
}

class _DayToDayListItem {
  final DateTime date;
  final _DailyStat newCases;
  final _DailyStat recovered;
  final _DailyStat deaths;

  _DayToDayListItem({
    this.date,
    this.newCases,
    this.recovered,
    this.deaths,
  });
}

class _DailyStat {
  final int previous;
  final int current;

  _DailyStat({
    this.previous,
    this.current,
  });

  int get difference => current - previous;
}
