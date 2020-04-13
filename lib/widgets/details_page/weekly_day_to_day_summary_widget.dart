import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyDayToDaySummaryWidget extends StatelessWidget {
  final List<_DayToDayListItem> _list = [];

  WeeklyDayToDaySummaryWidget({
    Key key,
    Covid19CountryReport countryReport,
  }) : super(key: key) {
    final reversed = countryReport.lastWeekReports.reversed.toList();
    for (var i = 1; i < reversed.length; i++) {
      final currentDay = reversed[i];
      final previousDay = reversed[i - 1];
      final previousPreviousDay = i - 2 >= 0 ? reversed[i - 2] : null;
      _list.add(_DayToDayListItem(
        date: currentDay.date,
        deaths: _DailyStat(
          current: currentDay.deaths - previousDay.deaths,
          previous: previousPreviousDay != null
              ? previousDay.deaths - previousPreviousDay.deaths
              : null,
        ),
        newCases: _DailyStat(
          current: currentDay.confirmed - previousDay.confirmed,
          previous: previousPreviousDay != null
              ? previousDay.confirmed - previousPreviousDay.confirmed
              : null,
        ),
        recovered: _DailyStat(
          current: currentDay.recovered - previousDay.recovered,
          previous: previousPreviousDay != null
              ? previousDay.recovered - previousPreviousDay.recovered
              : null,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Covid19Theme.appBackgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Text(
              'Summary of the last ${_list.length} days',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list.reversed.toList()[index];
                return _DayToDaySummaryWidget(dayToDayItem: item);
              }),
        ],
      ),
    );
  }
}

class _DayToDaySummaryWidget extends StatelessWidget {
  final _DayToDayListItem dayToDayItem;
  static final _dateFormatter = DateFormat("dd. MMMM. yyyy");

  const _DayToDaySummaryWidget({Key key, this.dayToDayItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Container(
              color: Colors.white12,
              height: 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
                title: Text(
                  _dateFormatter.format(dayToDayItem.date),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _StatsItemWidget(
                        title: 'New cases',
                        value: dayToDayItem.newCases,
                      ),
                      _StatsItemWidget(
                        title: 'Recovered',
                        changeType: _StatsItemChangeType.increaseIsBetter,
                        value: dayToDayItem.recovered,
                      ),
                      _StatsItemWidget(
                        title: 'Deaths',
                        value: dayToDayItem.deaths,
                      ),
                    ])),
          ),
        ],
      ),
    );
  }
}

enum _StatsItemChangeType { decreaseIsBetter, increaseIsBetter }

class _StatsItemWidget extends StatelessWidget {
  static final _numberFormatter = NumberFormat();
  final Color _positiveIncrement = Colors.greenAccent;
  final Color _negativeIncrement = Colors.redAccent;

  final String title;
  final _StatsItemChangeType changeType;
  final _DailyStat value;

  const _StatsItemWidget({
    Key key,
    this.title,
    this.changeType = _StatsItemChangeType.decreaseIsBetter,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool gotBetter = true;
    if (value.previous != null) {
      switch (changeType) {
        case _StatsItemChangeType.decreaseIsBetter:
          gotBetter = value.current <= value.previous;
          break;
        case _StatsItemChangeType.increaseIsBetter:
          gotBetter = value.current >= value.previous;
          break;
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontSize: 15,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      Text(
        _numberFormatter.format(value.current),
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: gotBetter ? _positiveIncrement : _negativeIncrement,
        ),
      ),
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
