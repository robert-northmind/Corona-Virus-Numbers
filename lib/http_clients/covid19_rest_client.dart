import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String _covid19JsonUrlString =
    'https://pomber.github.io/covid19/timeseries.json';

class Covid19RestClient {
  static Future<Map<String, dynamic>> fetchCovidStats() async {
    final response = await http.get(_covid19JsonUrlString);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Something went wrong. Could not fetch latest corona statistics update.');
    }
  }

  static Future<String> fetchLastUpdateDate() async {
    HttpClient client = HttpClient();
    HttpClientRequest req =
        await client.getUrl(Uri.parse(_covid19JsonUrlString));
    HttpClientResponse response = await req.close();
    final lastUpdateDate =
        response.headers.value(HttpHeaders.lastModifiedHeader);
    return lastUpdateDate;
  }
}
