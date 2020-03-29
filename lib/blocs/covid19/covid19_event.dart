import 'package:corona_stats/models/covid19_country_report.dart';

abstract class Covid19Event {}

class Covid19NeedsUpdateEvent implements Covid19Event {}

class Covid19ErrorFetchEvent implements Covid19Event {
  final String errorText;
  Covid19ErrorFetchEvent(this.errorText);
}

class Covid19UpdatedEvent implements Covid19Event {
  final DateTime lastUpdateTime;
  final Map<String, Covid19CountryReport> countryReports;

  Covid19UpdatedEvent({this.lastUpdateTime, this.countryReports});
}
