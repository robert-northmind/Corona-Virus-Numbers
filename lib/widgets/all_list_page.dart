import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/blocs/covid19/covid19_bloc.dart';
import 'package:corona_stats/blocs/covid19/covid19_state.dart';
import 'package:corona_stats/blocs/favorites/fav_bloc.dart';
import 'package:corona_stats/blocs/favorites/fav_event.dart';
import 'package:corona_stats/utils/debouncer.dart';
import 'package:corona_stats/widgets/covid19_widget.dart';
import 'package:corona_stats/widgets/details_page/details_page_route.dart';
import 'package:corona_stats/widgets/reload_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corona_stats/widgets/loading_data_widget.dart';

class AllListPage extends StatefulWidget {
  @override
  _AllListPageState createState() => _AllListPageState();
}

class _AllListPageState extends State<AllListPage> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Covid19CountryReport> _filteredCountries = [];
  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<Covid19Bloc, Covid19State>(
      bloc: BlocProvider.of<Covid19Bloc>(context),
      builder: (context, state) {
        if (state is Covid19ErrorFetchState) {
          return ReloadDataWidget();
        } else if (state is Covid19NoDataState) {
          return LoadingDataWidget();
        } else if (state is Covid19HasDataState) {
          if (_searchString.isEmpty) {
            _filteredCountries = state.countryReports.values.toList();
          }
          return Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: 'Search for a country...',
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                      _searchString = string;
                      _filteredCountries =
                          state.countryReports.values.where((report) {
                        return report.country
                            .toLowerCase()
                            .contains(string.toLowerCase());
                      }).toList();
                    });
                  });
                },
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  itemBuilder: (context, position) {
                    final countryReport = _filteredCountries[position];
                    return GestureDetector(
                      child: Covid19Widget(
                        countryReport: countryReport,
                        onFavoriteTapped: () {
                          BlocProvider.of<FavBloc>(context)
                              .add(FavEvent(country: countryReport.country));
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPageRoute(
                                      countryReport: countryReport,
                                    )));
                      },
                    );
                  },
                  itemCount: _filteredCountries.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: screenWidth * 0.00134),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
