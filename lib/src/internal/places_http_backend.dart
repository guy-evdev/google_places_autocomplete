import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/place_models.dart';
import 'backend.dart';

class PlacesHttpBackend implements PlacesBackend {
  PlacesHttpBackend({required this.apiKey, this.proxyBaseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _defaultBaseUrl = 'https://places.googleapis.com/v1';

  final String apiKey;
  final String? proxyBaseUrl;
  final http.Client _httpClient;

  String get _baseUrl => proxyBaseUrl ?? _defaultBaseUrl;

  @override
  Future<List<PlaceSuggestion>> autocomplete(AutocompleteRequest request) async {
    final response = await _post(path: 'places:autocomplete', body: request.toRestJson(), fieldMask: '*');
    final suggestions = ((response['suggestions'] as List?) ?? <Object?>[])
        .whereType<Map>()
        .map((item) => item.cast<String, Object?>())
        .where((item) => item['placePrediction'] != null)
        .map(PlaceSuggestion.fromRestJson)
        .toList(growable: false);
    return suggestions;
  }

  @override
  Future<PlaceData> fetchPlace(PlaceDetailsRequest request) async {
    final path = request.placeId.startsWith('places/')
        ? request.placeId
        : 'places/${Uri.encodeComponent(request.placeId)}';
    final response = await _get(
      path: path,
      fieldMask: request.detailsFieldMask,
      queryParameters: <String, String>{
        if (request.languageCode != null) 'languageCode': request.languageCode!,
        if (request.regionCode != null) 'regionCode': request.regionCode!,
        if (request.sessionToken != null) 'sessionToken': request.sessionToken!.value,
      },
    );
    return PlaceData.fromJson(response);
  }

  @override
  Future<List<PlaceData>> searchText(TextSearchRequest request) async {
    final response = await _post(
      path: 'places:searchText',
      body: request.toRestJson(),
      fieldMask: request.searchFieldMask,
    );
    return ((response['places'] as List?) ?? <Object?>[])
        .whereType<Map>()
        .map((item) => PlaceData.fromJson(item.cast<String, Object?>()))
        .toList(growable: false);
  }

  @override
  Future<List<PlaceData>> searchNearby(NearbySearchRequest request) async {
    final response = await _post(
      path: 'places:searchNearby',
      body: request.toRestJson(),
      fieldMask: request.searchFieldMask,
    );
    return ((response['places'] as List?) ?? <Object?>[])
        .whereType<Map>()
        .map((item) => PlaceData.fromJson(item.cast<String, Object?>()))
        .toList(growable: false);
  }

  @override
  Future<void> close() async {
    _httpClient.close();
  }

  Future<Map<String, Object?>> _post({
    required String path,
    required Map<String, Object?> body,
    required String fieldMask,
  }) async {
    final uri = _resolveUri(path);
    final response = await _httpClient.post(
      uri,
      headers: _headers(fieldMask: fieldMask),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, Object?>> _get({
    required String path,
    required String fieldMask,
    Map<String, String> queryParameters = const <String, String>{},
  }) async {
    final uri = _resolveUri(path, queryParameters: queryParameters);
    final response = await _httpClient.get(uri, headers: _headers(fieldMask: fieldMask));
    return _decode(response);
  }

  Uri _resolveUri(String path, {Map<String, String> queryParameters = const <String, String>{}}) {
    final normalizedBase = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse(
      '$normalizedBase/$normalizedPath',
    ).replace(queryParameters: queryParameters.isEmpty ? null : queryParameters);
  }

  Map<String, String> _headers({required String fieldMask}) {
    return <String, String>{
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': fieldMask,
    };
  }

  Map<String, Object?> _decode(http.Response response) {
    final dynamic decoded = response.body.isEmpty ? <String, Object?>{} : jsonDecode(response.body);
    final body = (decoded as Map).cast<String, Object?>();
    if (response.statusCode >= 400) {
      final error = (body['error'] as Map?)?.cast<String, Object?>();
      throw PlacesException(
        (error?['message'] ?? 'Google Places request failed.') as String,
        statusCode: response.statusCode,
        details: body,
      );
    }
    return body;
  }
}
