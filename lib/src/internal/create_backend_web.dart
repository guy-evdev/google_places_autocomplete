import 'backend.dart';
import 'places_web_backend.dart';

PlacesBackend createPlacesBackend({
  required String apiKey,
  String? proxyBaseUrl,
  String? timeZoneBaseUrl,
  Object? httpClient,
}) {
  return PlacesWebBackend(
    apiKey: apiKey,
    proxyBaseUrl: proxyBaseUrl,
    timeZoneBaseUrl: timeZoneBaseUrl,
  );
}
