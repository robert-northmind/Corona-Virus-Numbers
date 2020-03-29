import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/blocs/favorites/fav_bloc.dart';
import 'package:corona_stats/blocs/favorites/fav_state.dart';
import 'package:corona_stats/utils/theme.dart';
import 'package:corona_stats/widgets/simple_charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Covid19Widget extends StatelessWidget {
  final Covid19CountryReport countryReport;
  Covid19Widget({@required this.countryReport});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Covid19Theme.appBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: _TitleWidget(
                            title: '${countryReport.country}', fontSize: 16.0),
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: _FavButton(
                    key: Key('${countryReport.country}'),
                    country: countryReport.country,
                  ),
                ),
              ],
            ),
            _TitleWidget(
              title: '${countryReport.reports.first.confirmed}',
              fontSize: 20.0,
            ),
            _TitleWidget(
              title: 'total infected',
              fontSize: 12.0,
            ),
            Container(
              height: 120,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SimpleBarChart(countryReport: countryReport),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SimpleLineChart(countryReport: countryReport),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _TitleWidget(
              title: countryReport.getDiffInfected(),
              fontSize: 20.0,
            ),
            _TitleWidget(
              title: 'number infected last 7 days',
              fontSize: 12.0,
            ),
            SizedBox(height: 20),
            if (countryReport.getTotalRecovered() != null)
              _TitleWidget(
                title: 'Total ${countryReport.getTotalRecovered()} recovered',
                fontSize: 12.0,
              ),
            if (countryReport.getTotalRecovered() == null)
              _TitleWidget(
                title: 'No info about recovered',
                fontSize: 12.0,
              ),
            if (countryReport.getTotalDeaths() != null)
              _TitleWidget(
                title: 'Total ${countryReport.getTotalDeaths()} deaths',
                fontSize: 12.0,
              ),
          ],
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  _TitleWidget({this.title, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        fontFamily: 'Open Sans',
        fontSize: fontSize,
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  final String country;

  const _FavButton({Key key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavBloc, FavState>(
      bloc: BlocProvider.of<FavBloc>(context),
      builder: (context, state) {
        bool isFav = state.favCountries.contains(country);
        return Padding(
          padding: const EdgeInsets.only(right: 13),
          child: Icon(
            isFav ? Icons.star : Icons.star_border,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
