import 'package:corona_stats/utils/date_parsing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'covid19_daily_report.dart';

class _Constants {
  static int nbrReportDays = 8;
  static String countryKey = 'country';
  static String reportsKey = 'reports';
}

class Covid19CountryReport {
  final String country;
  final List<Covid19DailyReport> reports;
  static final _numberFormatter = NumberFormat();

  Covid19CountryReport({@required this.reports, @required this.country});

  factory Covid19CountryReport.from({
    @required String country,
    @required List<dynamic> reportsListData,
  }) {
    final reducedReportsData =
        reportsListData.reversed.take(_Constants.nbrReportDays).toList();
    final reports = reducedReportsData
        .map((reportDataJson) {
          final dateTime = DateParsing.dateFromPomberGithubCovidString(
              reportDataJson['date']);
          reportDataJson['date'] = dateTime;
          final report = Covid19DailyReport.fromJson(json: reportDataJson);
          return report;
        })
        .where((report) => report.confirmed != null || report.confirmed != -1)
        .toList();
    return Covid19CountryReport(country: country, reports: reports);
  }

  @override
  String toString() {
    return '${_Constants.countryKey}: $country, ${_Constants.reportsKey}: $reports';
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> reportsJson = reports.map((report) {
      return report.toJson();
    }).toList();
    return {
      _Constants.countryKey: country,
      _Constants.reportsKey: reportsJson,
    };
  }

  factory Covid19CountryReport.fromJson({
    @required Map<String, dynamic> json,
  }) {
    try {
      final country = json[_Constants.countryKey];
      List<dynamic> reportsJson = json[_Constants.reportsKey];
      List<Covid19DailyReport> reports = reportsJson.map((reportDataJson) {
        Map<String, dynamic> jsonTest = reportDataJson as Map<String, dynamic>;
        return Covid19DailyReport.fromJson(json: jsonTest);
      }).toList();

      final countryReports =
          Covid19CountryReport(country: country, reports: reports);
      return countryReports;
    } catch (_) {
      return null;
    }
  }

  String getDiffInfected() {
    int oldestData = reports.last.confirmed;
    int newestData = reports.first.confirmed;
    final diff = newestData - oldestData;
    final diffStr = _numberFormatter.format(diff);
    return diff >= 0 ? '+$diffStr' : '$diffStr';
  }

  int _cachedTotalConfirmed;
  int getTotalConfirmed() {
    if (_cachedTotalConfirmed != null) {
      return _cachedTotalConfirmed;
    }
    int total = reports.firstWhere((report) {
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
    int total = reports.firstWhere((report) {
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
    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];
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

    final graphData = reports.map((report) {
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

    int min = reports.last.confirmed;
    int max = reports.first.confirmed;
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
    for (int i = 0; i < reports.length - 1; i++) {
      int diff = reports[i].confirmed - reports[i + 1].confirmed;
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

    for (int i = 0; i < reports.length - 1; i++) {
      int diff = reports[i].confirmed - reports[i + 1].confirmed;
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
