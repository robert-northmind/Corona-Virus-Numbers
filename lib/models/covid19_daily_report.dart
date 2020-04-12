import 'package:flutter/material.dart';

class _Constants {
  static String dateKey = 'date';
  static String confirmedKey = 'confirmed';
  static String deathsKey = 'deaths';
  static String recoveredKey = 'recovered';
}

class Covid19DailyReport {
  final DateTime date;
  final int confirmed;
  final int deaths;
  final int recovered;

  Covid19DailyReport({
    @required this.date,
    @required this.confirmed,
    @required this.deaths,
    @required this.recovered,
  });

  @override
  String toString() {
    return '${_Constants.dateKey}: $date, ${_Constants.confirmedKey}: $confirmed, ${_Constants.deathsKey}: $deaths, ${_Constants.recoveredKey}: $recovered';
  }

  Map<String, dynamic> toJson() {
    return {
      _Constants.dateKey: date.toIso8601String(),
      _Constants.confirmedKey: confirmed ?? -1,
      _Constants.deathsKey: deaths ?? -1,
      _Constants.recoveredKey: recovered ?? -1,
    };
  }

  factory Covid19DailyReport.fromJson({
    @required Map<String, dynamic> json,
  }) {
    DateTime date;
    try {
      date = json[_Constants.dateKey] as DateTime;
    } catch (_) {
      final dateString = json[_Constants.dateKey] as String;
      date = DateTime.parse(dateString);
    }
    final confirmed = json[_Constants.confirmedKey] as int ?? -1;
    final deaths = json[_Constants.deathsKey] as int ?? -1;
    final recovered = json[_Constants.recoveredKey] as int ?? -1;
    return Covid19DailyReport(
      date: date,
      confirmed: confirmed,
      deaths: deaths,
      recovered: recovered,
    );
  }
}
