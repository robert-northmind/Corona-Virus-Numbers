import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:equatable/equatable.dart';

class Covid19StateConstants {
  static String reportsKey = 'countryReports';
  static String dateKey = 'lastUpdateTime';
  static String stateKey = 'stateKey';
  static String hasDataKey = 'hasDataKey';
  static String hasNoDataKey = 'hasNoDataKey';
}

abstract class Covid19State extends Equatable {
  Map<String, dynamic> toJson();
}

class Covid19ErrorFetchState extends Covid19State {
  final String errorText;
  Covid19ErrorFetchState(this.errorText);

  Map<String, dynamic> toJson() {
    return {
      Covid19StateConstants.stateKey: Covid19StateConstants.hasNoDataKey,
    };
  }

  @override
  List<Object> get props => [errorText];
}

class Covid19NoDataState extends Covid19State {
  Map<String, dynamic> toJson() {
    return {
      Covid19StateConstants.stateKey: Covid19StateConstants.hasNoDataKey,
    };
  }

  @override
  List<Object> get props => [];
}

class Covid19HasDataState extends Covid19State {
  final DateTime lastUpdateTime;
  final Map<String, Covid19CountryReport> countryReports;

  Covid19HasDataState({this.countryReports, this.lastUpdateTime});

  @override
  List<Object> get props => [lastUpdateTime];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> countryReportsJson = {};
    countryReports.forEach((key, value) {
      countryReportsJson[key] = value.toJson();
    });
    return {
      Covid19StateConstants.reportsKey: countryReportsJson,
      Covid19StateConstants.dateKey: lastUpdateTime.toIso8601String(),
      Covid19StateConstants.stateKey: Covid19StateConstants.hasDataKey,
    };
  }

  factory Covid19HasDataState.fromJson({Map<String, dynamic> json}) {
    final countryReportsJson =
        json[Covid19StateConstants.reportsKey] as Map<String, dynamic>;
    final Map<String, Covid19CountryReport> countryReports = {};
    countryReportsJson.forEach((key, value) {
      countryReports[key] = Covid19CountryReport.fromJson(json: value);
    });

    final lastUpdateTimeStr = json[Covid19StateConstants.dateKey] as String;

    final lastUpdateTime = DateTime.parse(lastUpdateTimeStr);

    return Covid19HasDataState(
      countryReports: countryReports,
      lastUpdateTime: lastUpdateTime,
    );
  }
}
