import 'package:http/http.dart' as http;

import 'backend.dart';
import 'places_http_backend.dart';

PlacesBackend createPlacesBackend({required String apiKey, String? proxyBaseUrl, Object? httpClient}) {
  return PlacesHttpBackend(
    apiKey: apiKey,
    proxyBaseUrl: proxyBaseUrl,
    httpClient: httpClient is http.Client ? httpClient : null,
  );
}
