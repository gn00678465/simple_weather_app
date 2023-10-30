class GooglePlacesAPIException implements Exception {
  String _cause;

  GooglePlacesAPIException(this._cause);

  String toString() => '${this.runtimeType} - $_cause';
}
