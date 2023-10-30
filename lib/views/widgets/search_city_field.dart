import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:simple_weather_app/utils/debounce.dart';
import 'package:simple_weather_app/services/google_places/google_places.dart';
import 'package:simple_weather_app/model/places_model.dart';

const String _apikey = String.fromEnvironment('GOOGLE_API');

final _google_places_sdk = GooglePlaces(_apikey);

class SearchCityField extends StatefulWidget {
  const SearchCityField({super.key});

  @override
  State<SearchCityField> createState() => _SearchCityField();
}

class _SearchCityField extends State<SearchCityField> {
  String? _currentQuery;

  late Iterable<PlacesModel> _lastOptions = <PlacesModel>[];

  late final Debounceable<Iterable<PlacesModel>?, String> _debouncedSearch;

  Future<Iterable<PlacesModel>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<PlacesModel> options;

    try {
      final result = await _google_places_sdk.autocomplete(query);

      debugPrint('result: ${result.toString()}');

      options = result?.map((item) {
            debugPrint(item.toString());
            return PlacesModel.fromJson(item);
          }) ??
          [];
    } catch (e) {
      debugPrint('error: $e');
      rethrow;
    }

    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    _debouncedSearch = debounce<Iterable<PlacesModel>?, String>(_search);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController controller,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return CupertinoSearchTextField(
          controller: controller,
          placeholder: '搜尋城市或機場',
          placeholderStyle: const TextStyle(
            fontSize: 16,
            color: CupertinoColors.inactiveGray,
          ),
          itemColor: CupertinoColors.inactiveGray,
          itemSize: 16,
          prefixInsets: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
          decoration: const BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusNode: focusNode,
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final Iterable<PlacesModel>? options =
            await _debouncedSearch(textEditingValue.text);
        if (options == null) {
          return _lastOptions;
        }
        _lastOptions = options;
        return options;
      },
    );
  }
}
