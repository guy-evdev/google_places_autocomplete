import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_autocomplete/google_places_autocomplete.dart';

void main() {
  group('AutocompleteRequest', () {
    test('serializes the new API request shape', () {
      final request = AutocompleteRequest(
        input: 'coffee',
        sessionToken: AutocompleteSessionToken.fromValue('session'),
        languageCode: 'en',
        regionCode: 'us',
        locationBias: LocationBias.circle(
          center: const PlaceCoordinates(latitude: 32.08, longitude: 34.78),
          radiusMeters: 500,
        ),
        includedPrimaryTypes: const <String>['cafe'],
        includedRegionCodes: const <String>['us'],
        includePureServiceAreaBusinesses: true,
      );

      expect(request.toRestJson(), <String, Object?>{
        'input': 'coffee',
        'sessionToken': 'session',
        'languageCode': 'en',
        'regionCode': 'us',
        'locationBias': <String, Object?>{
          'circle': <String, Object?>{
            'center': <String, Object?>{'latitude': 32.08, 'longitude': 34.78},
            'radius': 500.0,
          },
        },
        'includedPrimaryTypes': const <String>['cafe'],
        'includedRegionCodes': const <String>['us'],
        'includePureServiceAreaBusinesses': true,
      });
    });

    test('rejects simultaneous bias and restriction', () {
      final request = AutocompleteRequest(
        input: 'coffee',
        locationBias: LocationBias.circle(
          center: const PlaceCoordinates(latitude: 0, longitude: 0),
          radiusMeters: 100,
        ),
        locationRestriction: LocationRestriction.circle(
          center: const PlaceCoordinates(latitude: 0, longitude: 0),
          radiusMeters: 100,
        ),
      );

      expect(request.validate, throwsA(isA<PlacesException>()));
    });
  });

  test('parses rich place data', () {
    final place = PlaceData.fromJson(<String, Object?>{
      'id': 'place-1',
      'name': 'places/place-1',
      'displayName': <String, Object?>{
        'text': 'Coffee Lab',
        'languageCode': 'en',
      },
      'formattedAddress': '1 Main St',
      'location': <String, Object?>{'latitude': 1.2, 'longitude': 3.4},
      'rating': 4.7,
      'userRatingCount': 128,
      'photos': <Map<String, Object?>>[
        <String, Object?>{'name': 'photo-1', 'widthPx': 800, 'heightPx': 600},
      ],
    });

    expect(place.id, 'place-1');
    expect(place.resourceName, 'places/place-1');
    expect(place.displayName?.text, 'Coffee Lab');
    expect(place.location?.latitude, 1.2);
    expect(place.photos, hasLength(1));
  });
}
