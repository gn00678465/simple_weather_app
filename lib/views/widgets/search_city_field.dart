import 'package:flutter/cupertino.dart';

class SearchCityField extends StatefulWidget {
  const SearchCityField({super.key});

  @override
  State<SearchCityField> createState() => _SearchCityField();
}

class _SearchCityField extends State<SearchCityField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: _controller,
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
      onChanged: (String value) {
        debugPrint('change: $value');
      },
      onSubmitted: (String value) {
        debugPrint('submitted: $value');
      },
    );
  }
}
