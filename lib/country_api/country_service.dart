import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1/all';
  final http.Client client;

  CountryService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> fetchCountries() async {
    try {
      final response = await client.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((country) {
          final name = country['name']['common'];
          final latlng = country['latlng'];
          return {
            'name': name,
            'latitude': latlng[0],
            'longitude': latlng[1],
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch countries');
      }
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }
  }
}
