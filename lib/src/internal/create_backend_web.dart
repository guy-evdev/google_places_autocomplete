import 'backend.dart';
import 'places_web_backend.dart';

PlacesBackend createPlacesBackend({required String apiKey, String? proxyBaseUrl, Object? httpClient}) {
  return PlacesWebBackend(apiKey: apiKey);
}
