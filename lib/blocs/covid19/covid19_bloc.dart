import 'package:corona_stats/blocs/covid19/covid19_event.dart';
import 'package:corona_stats/blocs/covid19/covid19_state.dart';
import 'package:corona_stats/repositories/covid_19_repo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class Covid19Bloc extends HydratedBloc<Covid19Event, Covid19State> {
  Covid19Bloc() {
    add(Covid19NeedsUpdateEvent());
  }

  @override
  Covid19State get initialState {
    return super.initialState ?? Covid19NoDataState();
  }

  @override
  Stream<Covid19State> mapEventToState(Covid19Event event) async* {
    if (event is Covid19NeedsUpdateEvent) {
      if (state is! Covid19HasDataState) {
        yield Covid19NoDataState();
      }
      Future.delayed(Duration(seconds: 1)).then((_) {
        _fetchNewCovidData();
      });
    } else if (event is Covid19UpdatedEvent) {
      yield Covid19HasDataState(
        countryReports: event.countryReports,
        lastUpdateTime: event.lastUpdateTime,
      );
    } else if (event is Covid19ErrorFetchEvent) {
      yield Covid19ErrorFetchState(event.errorText);
    }
  }

  @override
  Covid19State fromJson(Map<String, dynamic> source) {
    try {
      if (source[Covid19StateConstants.stateKey] ==
          Covid19StateConstants.hasDataKey) {
        return Covid19HasDataState.fromJson(json: source);
      } else {
        return Covid19NoDataState();
      }
    } catch (_) {
      return Covid19NoDataState();
    }
  }

  @override
  Map<String, dynamic> toJson(Covid19State state) {
    try {
      return state.toJson();
    } catch (_) {
      return {};
    }
  }

  Future<void> _fetchNewCovidData() async {
    try {
      final serverLastUpdateDate = await Covid19Repo.getLastReportsDate();
      bool needsUpdate = false;
      if (state is Covid19NoDataState || serverLastUpdateDate == null) {
        needsUpdate = true;
      } else if (state is Covid19HasDataState) {
        final hasDataState = state as Covid19HasDataState;
        needsUpdate =
            hasDataState?.lastUpdateTime?.isBefore(serverLastUpdateDate) ??
                true;
      }

      if (needsUpdate) {
        final countryReports = await Covid19Repo.getReports();
        add(Covid19UpdatedEvent(
          countryReports: countryReports,
          lastUpdateTime: serverLastUpdateDate,
        ));
      }
    } catch (error) {
      add(Covid19ErrorFetchEvent('$error'));
    }
  }
}
