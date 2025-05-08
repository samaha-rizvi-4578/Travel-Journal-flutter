import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:travel_journel/country_api/country_service.dart';

// Mock class
class MockHttpClient extends Mock implements http.Client {}


void main() {
  late CountryService countryService;
  late MockHttpClient mockClient;

  setUp(() {
  mockClient = MockHttpClient();
  countryService = CountryService(client: mockClient);
});

  test('returns list of countries when API call is successful', () async {
    final mockResponse = jsonEncode([
      {
        "name": {"common": "Pakistan"},
        "latlng": [30.3753, 69.3451]
      },
      {
        "name": {"common": "Japan"},
        "latlng": [36.2048, 138.2529]
      }
    ]);

    // Override the actual HTTP call
    when(() => mockClient.get(Uri.parse('https://restcountries.com/v3.1/all')))
        .thenAnswer((_) async => http.Response(mockResponse, 200));

    // Use dependency injection to inject mockClient if needed (e.g., refactor CountryService)
    final response = await countryService.fetchCountries();

    expect(response.length, 2);
    expect(response[0]['name'], 'Pakistan');
    expect(response[1]['latitude'], 36.2048);
  });

  test('throws exception when API call fails', () async {
    when(() => mockClient.get(Uri.parse('https://restcountries.com/v3.1/all')))
        .thenAnswer((_) async => http.Response('Internal Server Error', 500));

    expect(
      () => countryService.fetchCountries(),
      throwsA(isA<Exception>()),
    );
  });
}
