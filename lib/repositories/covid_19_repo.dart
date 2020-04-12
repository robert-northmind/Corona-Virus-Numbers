import 'package:corona_stats/models/covid19_country_report.dart';
import 'package:corona_stats/http_clients/covid19_rest_client.dart';
import 'package:corona_stats/utils/date_parsing.dart';
import 'package:corona_stats/models/covid19_daily_report.dart';

String _allWorldCountry = 'All World';

class Covid19Repo {
  static Future<Map<String, Covid19CountryReport>> getReports() async {
    try {
      final json = await Covid19RestClient.fetchCovidStats();
      final Map<String, Covid19CountryReport> countryReportsMap = {};
      countryReportsMap[_allWorldCountry] = Covid19CountryReport(
        country: _allWorldCountry,
        lastWeekReports: [],
        allReports: [],
      );
      json.forEach((key, val) {
        final countryReports =
            Covid19CountryReport.from(country: key, reportsListData: val);
        countryReportsMap[countryReports.country] = countryReports;
      });
      final allWorld = _getAllCountriesReport(countryReportsMap);
      countryReportsMap[_allWorldCountry] = allWorld;
      return countryReportsMap;
    } catch (error) {
      throw Exception(
          'Something went wrong. Could not fetch latest corona statistics update.');
    }
  }

  static Future<DateTime> getLastReportsDate() async {
    try {
      final lastUpdateString = await Covid19RestClient.fetchLastUpdateDate();
      final lastUpdateDate =
          DateParsing.dateFromLastUpdateTime(lastUpdateString);
      return lastUpdateDate;
    } catch (error) {
      return null;
    }
  }

  static Covid19CountryReport _getAllCountriesReport(
      Map<String, Covid19CountryReport> countryReportsMap) {
    List<Covid19CountryReport> allCountriesList =
        countryReportsMap.values.toList();

    final firstCountry = allCountriesList[1];
    List<List<dynamic>> reportInfoAllWorld = [];
    for (int i = 0; i < firstCountry.allReports.length; i++) {
      reportInfoAllWorld.add([DateTime.now(), 0, 0, 0]);
    }
    allCountriesList.forEach((country) {
      for (int j = 0; j < country.allReports.length; j++) {
        final dayReport = country.allReports[j];
        if (dayReport.date != null) {
          reportInfoAllWorld[j][0] = dayReport.date;
        }
        if (dayReport.confirmed != null && dayReport.confirmed > 0) {
          reportInfoAllWorld[j][1] += dayReport.confirmed;
        }
        if (dayReport.deaths != null && dayReport.deaths > 0) {
          reportInfoAllWorld[j][2] += dayReport.deaths;
        }
        if (dayReport.recovered != null && dayReport.recovered > 0) {
          reportInfoAllWorld[j][3] += dayReport.recovered;
        }
      }
    });

    List<Covid19DailyReport> allReports = [];
    reportInfoAllWorld.forEach((reportAllWorld) {
      DateTime date = reportAllWorld[0];
      int confirmed = reportAllWorld[1];
      int deaths = reportAllWorld[2];
      int recovered = reportAllWorld[3];
      allReports.add(
        Covid19DailyReport(
          confirmed: confirmed,
          recovered: recovered,
          deaths: deaths,
          date: date,
        ),
      );
    });

    List<Covid19DailyReport> weekDayReports = allReports
        .getRange(allReports.length - 8, allReports.length)
        .toList()
        .reversed
        .toList();

    return Covid19CountryReport(
      country: _allWorldCountry,
      lastWeekReports: weekDayReports,
      allReports: allReports,
    );
  }
}
