import 'package:corona_stats/blocs/covid19/covid19_bloc.dart';
import 'package:corona_stats/blocs/covid19/covid19_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReloadDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text(
                'Something went wrong when loading data. Could not fetch the latest corona statistics update.'),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Try to get data again'),
              onPressed: () {
                BlocProvider.of<Covid19Bloc>(context)
                    .add(Covid19NeedsUpdateEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
