import 'package:corona_stats/utils/date_parsing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'covid19_daily_report.dart';

class _Constants {
  static int nbrWeekReportDays = 8;
  static String countryKey = 'country';
  static String lastWeekReportsKey = 'lastWeekReports';
  static String allReportsKey = 'allReports';
}

class Covid19CountryReport {
  final String country;
  final List<Covid19DailyReport> lastWeekReports;
  final List<Covid19DailyReport> allReports;
  static final _numberFormatter = NumberFormat();

  Covid19CountryReport(
      {@required this.lastWeekReports,
      @required this.allReports,
      @required this.country});

  factory Covid19CountryReport.from({
    @required String country,
    @required List<dynamic> reportsListData,
  }) {
    final allReports = reportsListData.map((reportDataJson) {
      final dateTime =
          DateParsing.dateFromPomberGithubCovidString(reportDataJson['date']);
      reportDataJson['date'] = dateTime;
      final report = Covid19DailyReport.fromJson(json: reportDataJson);
      return report;
    }).toList();

    final reducedReportsData =
        reportsListData.reversed.take(_Constants.nbrWeekReportDays).toList();
    final weekReports = reducedReportsData
        .map((reportDataJson) {
          final dateJsonValue = reportDataJson['date'];
          if (dateJsonValue is! DateTime) {
            final dateTime = DateParsing.dateFromPomberGithubCovidString(
                reportDataJson['date']);
            reportDataJson['date'] = dateTime;
          }
          final report = Covid19DailyReport.fromJson(json: reportDataJson);
          return report;
        })
        .where((report) => report.confirmed != null || report.confirmed != -1)
        .toList();
    return Covid19CountryReport(
      country: country,
      lastWeekReports: weekReports,
      allReports: allReports,
    );
  }

  @override
  String toString() {
    return '${_Constants.countryKey}: $country, ${_Constants.lastWeekReportsKey}: $lastWeekReports';
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> allReportsJson = allReports.map((report) {
      return report.toJson();
    }).toList();

    List<Map<String, dynamic>> lestWeekReportsJson =
        lastWeekReports.map((report) {
      return report.toJson();
    }).toList();

    return {
      _Constants.countryKey: country,
      _Constants.lastWeekReportsKey: lestWeekReportsJson,
      _Constants.allReportsKey: allReportsJson,
    };
  }

  factory Covid19CountryReport.fromJson({
    @required Map<String, dynamic> json,
  }) {
    try {
      final country = json[_Constants.countryKey];

      List<dynamic> lastWeekReportsJson = json[_Constants.lastWeekReportsKey];
      List<Covid19DailyReport> lastWeekReports =
          lastWeekReportsJson.map((reportDataJson) {
        Map<String, dynamic> dailyReportJson =
            reportDataJson as Map<String, dynamic>;
        return Covid19DailyReport.fromJson(json: dailyReportJson);
      }).toList();

      List<dynamic> allReportsJson = json[_Constants.allReportsKey];
      List<Covid19DailyReport> allReports =
          allReportsJson.map((reportDataJson) {
        Map<String, dynamic> dailyReportJson =
            reportDataJson as Map<String, dynamic>;
        return Covid19DailyReport.fromJson(json: dailyReportJson);
      }).toList();

      final countryReports = Covid19CountryReport(
        country: country,
        lastWeekReports: lastWeekReports,
        allReports: allReports,
      );
      return countryReports;
    } catch (_) {
      return null;
    }
  }

  String getDiffInfected() {
    int oldestData = lastWeekReports.last.confirmed;
    int newestData = lastWeekReports.first.confirmed;
    final diff = newestData - oldestData;
    final diffStr = _numberFormatter.format(diff);
    return diff >= 0 ? '+$diffStr' : '$diffStr';
  }

  int _cachedTotalConfirmed;
  int getTotalConfirmed() {
    if (_cachedTotalConfirmed != null) {
      return _cachedTotalConfirmed;
    }
    int total = lastWeekReports.firstWhere((report) {
      return report.confirmed != null && report.confirmed >= 0;
    }).confirmed;
    _cachedTotalConfirmed = total;
    return _cachedTotalConfirmed;
  }

  int _cachedTotalDeaths;
  int getTotalDeaths() {
    if (_cachedTotalDeaths != null) {
      return _cachedTotalDeaths;
    }
    int total = lastWeekReports.firstWhere((report) {
      return report.deaths != null && report.deaths >= 0;
    }).deaths;
    _cachedTotalDeaths = total;
    return _cachedTotalDeaths;
  }

  int _cachedTotalRecovered;
  int getTotalRecovered() {
    if (_cachedTotalRecovered != null) {
      return _cachedTotalRecovered;
    }

    Covid19DailyReport matchedReport;
    for (int i = 0; i < lastWeekReports.length; i++) {
      final report = lastWeekReports[i];
      if (report != null && report.recovered != null && report.recovered >= 0) {
        matchedReport = report;
        break;
      }
    }

    if (matchedReport != null) {
      _cachedTotalRecovered = matchedReport.recovered;
    }
    return _cachedTotalRecovered;
  }

  List<double> _cachedLineGraphData;
  List<double> getLineGraphData() {
    if (_cachedLineGraphData != null) {
      return _cachedLineGraphData;
    }

    final graphData = lastWeekReports.map((report) {
      return report.confirmed / 1.0;
    }).toList();
    graphData.removeLast();

    Set<double> checkAllSame = Set<double>.from(graphData);
    if (checkAllSame.length == 1) {
      graphData[graphData.length - 1] = graphData[graphData.length - 1] + 1;
    }
    _cachedLineGraphData = graphData.reversed.toList();

    return _cachedLineGraphData;
  }

  double _cachedVerticalPaddingFactor;
  double lineGraphVerticalPaddingFactor() {
    if (_cachedVerticalPaddingFactor != null) {
      return _cachedVerticalPaddingFactor;
    }

    int min = lastWeekReports.last.confirmed;
    int max = lastWeekReports.first.confirmed;
    if (min == null || max == null) {
      return 1;
    }
    int diff = max - min;
    diff = diff < 0 ? 0 : diff;
    _cachedVerticalPaddingFactor = 1 - (diff / max);
    if (_cachedVerticalPaddingFactor > 0.8) {
      _cachedVerticalPaddingFactor = 0.8;
    }

    return _cachedVerticalPaddingFactor;
  }

  List<BarChartData> _cachedBarChartData;
  List<BarChartData> barChartGtraphReports() {
    if (_cachedBarChartData != null) {
      return _cachedBarChartData;
    }

    List<BarChartData> data = [];
    for (int i = 0; i < lastWeekReports.length - 1; i++) {
      int diff =
          lastWeekReports[i].confirmed - lastWeekReports[i + 1].confirmed;
      diff = diff < 0 ? 0 : diff;
      data.add(BarChartData(index: i, value: diff));
    }
    data = data.reversed.toList();
    _cachedBarChartData = data;

    return data;
  }

  int _cachedBarChartMaxVal;
  int getBarChartMaxValue() {
    if (_cachedBarChartMaxVal != null) {
      return _cachedBarChartMaxVal;
    }

    List<int> data = [];
    int min;
    int max;

    for (int i = 0; i < lastWeekReports.length - 1; i++) {
      int diff =
          lastWeekReports[i].confirmed - lastWeekReports[i + 1].confirmed;
      diff = diff < 0 ? 0 : diff;
      if (min == null || diff < min) {
        min = diff;
      }
      if (max == null || diff > max) {
        max = diff;
      }
      data.add(diff);
    }

    if (min == null || max == null) {
      return 1;
    }
    int diff = max - min;
    if (max == 0) {
      return 10;
    }
    double factor = 1 - (diff / max);
    _cachedBarChartMaxVal = (max * (1 + 1.6 * factor)).round();
    return _cachedBarChartMaxVal;
  }
}

class BarChartData {
  final int value;
  final int index;
  BarChartData({this.value, this.index});

  @override
  String toString() {
    return '$value';
  }
}
