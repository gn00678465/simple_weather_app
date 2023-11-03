import 'dart:convert';

List<T> fromStringList<T>(List<String> stringList,
    {required T Function(Map<String, dynamic> json) decode}) {
  return stringList
      .asMap()
      .map(
        (key, value) => MapEntry(
          key,
          decode(jsonDecode(value) as Map<String, dynamic>),
        ),
      )
      .values
      .toList();
}

List<String> toStringList<T>(List<T> list) {
  return List.from(list)
      .asMap()
      .map((key, value) => MapEntry(key, jsonEncode(value)))
      .values
      .toList();
}
