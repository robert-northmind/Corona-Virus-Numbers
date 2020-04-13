import 'package:corona_stats/blocs/graph_history/graph_history_bloc.dart';
import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/main.dart';
import 'package:corona_stats/widgets/details_page/weekly_day_to_day_summary_widget.dart';
import 'package:corona_stats/widgets/details_page/summary_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPageRoute extends StatelessWidget {
  final Covid19CountryReport countryReport;

  const DetailsPageRoute({Key key, this.countryReport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GraphHistoryBloc>(
          create: ((BuildContext context) {
            return GraphHistoryBloc();
          }),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AppTitleWidget(
            title: countryReport.country,
          ),
        ),
        body: Container(
          child: BlocBuilder<GraphHistoryBloc, GraphHistoryState>(
            builder: (context, state) {
              final isAllTime =
                  state.graphHistoryTimeType == GraphHistoryTimeType.allTime;
              final reports = isAllTime
                  ? countryReport.allReports
                  : countryReport.lastWeekReports.reversed.toList();
              return ListView(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                children: <Widget>[
                  _GraphTimeframeSelectionWidget(
                    graphHistoryTimeType: state.graphHistoryTimeType,
                  ),
                  SummaryListTileWidget(
                    title: 'Total cases',
                    values: reports
                        .map(
                          (item) => item.confirmed,
                        )
                        .toList(),
                  ),
                  SummaryListTileWidget(
                    title: 'Deaths',
                    values: reports
                        .map(
                          (item) => item.deaths,
                        )
                        .toList(),
                  ),
                  SummaryListTileWidget(
                    title: 'Recovered',
                    values: reports
                        .map(
                          (item) => item.recovered,
                        )
                        .toList(),
                  ),
                  SummaryListTileWidget(
                    title: 'Active cases',
                    values: reports
                        .map(
                          (item) => item.confirmed - item.recovered,
                        )
                        .toList(),
                  ),
                  SummaryListTileWidget(
                    title: "Death rate",
                    isPercent: true,
                    values: reports.map((item) {
                      if (item.confirmed <= 0) {
                        return 0;
                      } else {
                        return item.deaths / item.confirmed.toDouble() * 100;
                      }
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  WeeklyDayToDaySummaryWidget(
                    key: Key('DayToDayListWidget'),
                    countryReport: countryReport,
                  ),
                  SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GraphTimeframeSelectionWidget extends StatelessWidget {
  final GraphHistoryTimeType graphHistoryTimeType;

  const _GraphTimeframeSelectionWidget({Key key, this.graphHistoryTimeType})
      : super(key: key);

  String _getStringValueForHistoryTimeType(GraphHistoryTimeType type) {
    switch (type) {
      case GraphHistoryTimeType.allTime:
        return 'all time';
      case GraphHistoryTimeType.lastSevenDays:
        return 'the last 7 days';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text('Show graph data from: '),
          DropdownButton<GraphHistoryTimeType>(
            value: graphHistoryTimeType,
            icon: Icon(Icons.show_chart),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red[600]),
            underline: Container(
              height: 2,
              color: Colors.red[600],
            ),
            onChanged: (GraphHistoryTimeType newValue) {
              print("changed to new Value: $newValue");
              BlocProvider.of<GraphHistoryBloc>(context)
                  .add(GraphHistoryEvent(graphHistoryTimeType: newValue));
              // setState(() {
              //   dropdownValue = newValue;
              // });
            },
            items: <GraphHistoryTimeType>[
              GraphHistoryTimeType.allTime,
              GraphHistoryTimeType.lastSevenDays
            ].map<DropdownMenuItem<GraphHistoryTimeType>>(
                (GraphHistoryTimeType value) {
              return DropdownMenuItem<GraphHistoryTimeType>(
                value: value,
                child: Text(' ${_getStringValueForHistoryTimeType(value)} '),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
