import '../models/place_models.dart';

abstract interface class PlacesBackend {
  Future<List<PlaceSuggestion>> autocomplete(AutocompleteRequest request);

  Future<PlaceData> fetchPlace(PlaceDetailsRequest request);

  Future<List<PlaceData>> searchText(TextSearchRequest request);

  Future<List<PlaceData>> searchNearby(NearbySearchRequest request);

  Future<void> close();
}
