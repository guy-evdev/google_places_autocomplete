import 'package:flutter/widgets.dart';

/// Localized UI strings used by the autocomplete widgets.
///
/// Provide custom values to localize inline, dialog, and fullscreen widget
/// text without replacing the package UI.
///
/// Example:
/// ```dart
/// const PlacesStrings(
///   searchHint: 'חיפוש מקום',
///   noResultsText: 'לא נמצאו תוצאות',
/// )
/// ```
@immutable
class PlacesStrings {
  const PlacesStrings({
    this.searchHint = 'Search places',
    this.loadingText = 'Loading places…',
    this.noResultsText = 'No matching places found.',
    this.errorText = 'Unable to load places.',
    this.retryText = 'Retry',
    this.poweredByGoogleLabel = 'Powered by Google',
    this.overlayTitle = 'Search places',
    this.closeLabel = 'Close',
    this.clearLabel = 'Clear search',
  });

  final String searchHint;
  final String loadingText;
  final String noResultsText;
  final String errorText;
  final String retryText;

  /// Accessibility label used for the Google attribution image.
  final String poweredByGoogleLabel;
  final String overlayTitle;
  final String closeLabel;

  /// Tooltip/semantic label for the field clear button.
  final String clearLabel;
}
