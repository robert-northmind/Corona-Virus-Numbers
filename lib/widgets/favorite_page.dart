import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/blocs/covid19/covid19_bloc.dart';
import 'package:corona_stats/blocs/covid19/covid19_state.dart';
import 'package:corona_stats/blocs/favorites/fav_bloc.dart';
import 'package:corona_stats/blocs/favorites/fav_event.dart';
import 'package:corona_stats/blocs/favorites/fav_state.dart';
import 'package:corona_stats/widgets/reload_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'covid19_widget.dart';
import 'loading_data_widget.dart';

class FavoritePage extends StatelessWidget {
  final VoidCallback goToAllListCallback;
  FavoritePage({this.goToAllListCallback});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<FavBloc, FavState>(
      bloc: BlocProvider.of<FavBloc>(context),
      builder: (context, favState) {
        return BlocBuilder<Covid19Bloc, Covid19State>(
          bloc: BlocProvider.of<Covid19Bloc>(context),
          builder: (context, covid19State) {
            if (favState.favCountries.isEmpty) {
              return _GoToAllCountriesWidget(
                goToAllListCallback: goToAllListCallback,
              );
            }

            if (covid19State is Covid19ErrorFetchState) {
              return ReloadDataWidget();
            } else if (covid19State is Covid19NoDataState) {
              return LoadingDataWidget();
            } else if (covid19State is Covid19HasDataState) {
              Map<String, Covid19CountryReport> favCountryReports = {};
              covid19State.countryReports.forEach((key, value) {
                if (favState.favCountries.contains(key)) {
                  favCountryReports[key] = value;
                }
              });

              return GridView.builder(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                itemBuilder: (context, position) {
                  final countryReporstList = favCountryReports.values.toList();
                  final countryReport = countryReporstList[position];
                  return GestureDetector(
                    child: Covid19Widget(countryReport: countryReport),
                    onTap: () {
                      _showRemoveFavDialog(
                          context: context, country: countryReport.country);
                    },
                  );
                },
                itemCount: favCountryReports.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: screenWidth * 0.00134),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  void _showRemoveFavDialog({BuildContext context, String country}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: null,
          content: Text("Remove $country from favorites?"),
          actions: <Widget>[
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                BlocProvider.of<FavBloc>(context)
                    .add(FavEvent(country: country));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _GoToAllCountriesWidget extends StatelessWidget {
  final VoidCallback goToAllListCallback;
  _GoToAllCountriesWidget({this.goToAllListCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: <Widget>[
          Text(
            'You don\'t have any bookmarks.\nYou can add bookmarks by\ntapping on a country in the\n\'All Countries\' tab',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 20,
            ),
          ),
          SizedBox(height: 25),
          RaisedButton(
            child: Text('Go to \'All Countries\''),
            onPressed: goToAllListCallback,
          )
        ],
      ),
    );
  }
}
