import 'package:intl/intl.dart';

class DateParsing {
  static DateTime dateFromPomberGithubCovidString(String dateString) {
    // Example format: 2020-3-21
    final dateComponents = dateString.split('-');
    if (dateComponents.length != 3) {
      return null;
    }
    String parsableDateString = dateComponents[0];
    if (dateComponents[1].length == 1) {
      parsableDateString += '0${dateComponents[1]}';
    } else if (dateComponents[1].length == 2) {
      parsableDateString += dateComponents[1];
    } else {
      return null;
    }

    if (dateComponents[2].length == 1) {
      parsableDateString += '0${dateComponents[2]}';
    } else if (dateComponents[2].length == 2) {
      parsableDateString += dateComponents[2];
    } else {
      return null;
    }
    return DateTime.parse(parsableDateString);
  }

  static DateTime dateFromLastUpdateTime(String dateString) {
    // Example format: Tue, 24 Mar 2020 18:57:34 GMT
    final dateFormatter = DateFormat("E, d MMM y H:m:s 'GMT'");
    final parsedDate = dateFormatter.parse(dateString);
    return parsedDate;
  }
}
