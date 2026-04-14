import 'package:http/http.dart' as http;

import 'internal/backend.dart';
import 'internal/create_backend.dart';
import 'models/place_models.dart';

/// Cross-platform client for Google Places API (New).
///
/// On Android, iOS, macOS, Windows, and Linux this uses HTTP requests to the
/// Places API (New). On web it uses the Google Maps JavaScript Places library.
///
/// Example:
/// ```dart
/// final client = PlacesClient(apiKey: 'your-key');
/// final suggestions = await client.autocomplete(
///   const AutocompleteRequest(input: 'coffee'),
/// );
/// ```
class PlacesClient {
  PlacesClient({required this.apiKey, this.proxyBaseUrl, http.Client? httpClient})
    : _backend = createPlacesBackend(apiKey: apiKey, proxyBaseUrl: proxyBaseUrl, httpClient: httpClient);

  PlacesClient.testing({required this.apiKey, required PlacesBackend backend, this.proxyBaseUrl}) : _backend = backend;

  final String apiKey;
  final String? proxyBaseUrl;
  final PlacesBackend _backend;

  /// Fetches autocomplete suggestions for the supplied request.
  Future<List<PlaceSuggestion>> autocomplete(AutocompleteRequest request) => _backend.autocomplete(request);

  /// Resolves a place id into rich place details.
  Future<PlaceData> fetchPlace(PlaceDetailsRequest request) => _backend.fetchPlace(request);

  /// Searches for places by free-text query.
  Future<List<PlaceData>> searchText(TextSearchRequest request) => _backend.searchText(request);

  /// Searches for places near a geographic restriction.
  Future<List<PlaceData>> searchNearby(NearbySearchRequest request) => _backend.searchNearby(request);

  /// Releases backend resources held by this client.
  Future<void> close() => _backend.close();
}
