part of open_weather_library;

class OpenWeatherAPIException implements Exception {
  String _cause;

  OpenWeatherAPIException(this._cause);

  String toString() => '${this.runtimeType} - $_cause';
}
