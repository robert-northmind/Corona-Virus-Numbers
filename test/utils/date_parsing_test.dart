import 'package:corona_stats/utils/date_parsing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateParsing', () {
    test('should parse date string from PomberGithub repo correctly', () {
      final dateString1 = '2020-3-21';
      final dateString2 = '2020-12-1';
      final dateString3 = '2020-5-4';
      final dateString4 = '2020-05-04';

      final date1 = DateParsing.dateFromPomberGithubCovidString(dateString1);
      final date2 = DateParsing.dateFromPomberGithubCovidString(dateString2);
      final date3 = DateParsing.dateFromPomberGithubCovidString(dateString3);
      final date4 = DateParsing.dateFromPomberGithubCovidString(dateString4);

      expect(date1.year, 2020);
      expect(date1.month, DateTime.march);
      expect(date1.day, 21);

      expect(date2.year, 2020);
      expect(date2.month, DateTime.december);
      expect(date2.day, 1);

      expect(date3.year, 2020);
      expect(date3.month, DateTime.may);
      expect(date3.day, 4);

      expect(date4.year, 2020);
      expect(date4.month, DateTime.may);
      expect(date4.day, 4);
    });
  });

  test('should parse date string from ISO date string correctly', () {
    final dateString1 = 'Tue, 24 Mar 2020 18:57:34 GMT';
    final dateString2 = 'Wed, 4 May 2020 08:07:04 GMT';

    final date1 = DateParsing.dateFromLastUpdateTime(dateString1);
    final date2 = DateParsing.dateFromLastUpdateTime(dateString2);

    expect(date1.year, 2020);
    expect(date1.month, DateTime.march);
    expect(date1.day, 24);

    expect(date2.year, 2020);
    expect(date2.month, DateTime.may);
    expect(date2.day, 4);
  });
}
