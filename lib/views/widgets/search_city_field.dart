import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_weather_app/model/weather_model.dart';
import 'package:simple_weather_app/model/places_model.dart';
import 'package:simple_weather_app/views/screens/weather_popup_surface.dart';
import 'package:simple_weather_app/utils/debounce.dart';
import 'package:simple_weather_app/services/google_places/google_places.dart';

const String _googlePlacesKey = String.fromEnvironment('GOOGLE_API');

final _googlePlacesSdk = GooglePlaces(_googlePlacesKey);

class SearchCityField extends StatefulWidget {
  const SearchCityField({super.key, this.onFocusChanged});

  final void Function(bool)? onFocusChanged;

  @override
  State<SearchCityField> createState() => _SearchCityField();
}

class _SearchCityField extends State<SearchCityField> {
  String? _currentQuery;
  late bool _isFocused;
  final Duration _duration = const Duration(milliseconds: 200);
  final double _width = 50;

  late Iterable<PlacesModel> _lastOptions = <PlacesModel>[];

  late final Debounceable<Iterable<PlacesModel>?, String> _debouncedSearch;

  Future<Iterable<PlacesModel>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<PlacesModel> options;

    try {
      final result = await _googlePlacesSdk.autocomplete(query);

      options =
          result?.map((item) => PlacesModel.fromJson(item)).toList() ?? [];
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

  void _onFocus() {
    _isFocused = true;
    widget.onFocusChanged?.call(_isFocused);
  }

  void _onBlur() {
    _isFocused = false;
    widget.onFocusChanged?.call(_isFocused);
  }

  @override
  void initState() {
    _isFocused = false;
    _debouncedSearch = debounce<Iterable<PlacesModel>?, String>(_search);
    super.initState();
  }

  Future<WeatherModel?> _showPopup(
      {required double lat, required double lng}) async {
    return await showCupertinoModalPopup<WeatherModel?>(
      context: context,
      builder: (BuildContext context) => WeatherPopupSurface(
        lat: lat,
        lng: lng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) => Row(
        children: [
          Flexible(
            child: AnimatedContainer(
              duration: _duration,
              width: _isFocused
                  ? MediaQuery.of(context).size.width - _width
                  : MediaQuery.of(context).size.width,
              child: Autocomplete(
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
                    prefixInsets:
                        const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    decoration: const BoxDecoration(
                      color: CupertinoColors.darkBackgroundGray,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusNode: focusNode,
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    onTap: _onFocus,
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
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<PlacesModel> onSelected,
                  Iterable<PlacesModel> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.white,
                      elevation: 10,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final PlacesModel option = options.elementAt(index);
                            return ListTile(
                              title: Text(option.description),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (PlacesModel selection) async {
                  final result =
                      await _googlePlacesSdk.placeDetail(selection.place_id);
                  if (result != null) {
                    final location = result['geometry']['location'];
                    final res = await _showPopup(
                      lat: location['lat'],
                      lng: location['lng'],
                    );
                    if (res != null) {
                    }
                  }
                },
                displayStringForOption: (PlacesModel option) {
                  return option.description;
                },
              ),
            ),
          ),
          SlideInText(
            isFocused: _isFocused,
            duration: _duration,
            width: _width,
            onTap: () {
              FocusScope.of(context).unfocus();
              _onBlur();
            },
          ),
        ],
      ),
    );
  }
}

class SlideInText extends StatefulWidget {
  const SlideInText({
    super.key,
    required this.isFocused,
    required this.duration,
    required this.width,
    this.onTap,
  });

  final Duration duration;
  final bool isFocused;
  final double width;
  final VoidCallback? onTap;

  @override
  State<SlideInText> createState() => _SlideInText();
}

class _SlideInText extends State<SlideInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  Duration get duration => widget.duration;

  bool get isFocused => widget.isFocused;

  double get width => widget.width;

  @override
  void initState() {
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(width, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFocused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        width: isFocused ? width : 0,
        duration: duration,
        child: SlideTransition(
          position: _animation,
          child: const Text('取消'),
        ),
      ),
    );
  }
}
