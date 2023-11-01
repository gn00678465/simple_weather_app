import 'dart:convert';

List<Map<String, dynamic>> fromStringList(List<String> stringList) {
  return stringList
      .asMap()
      .map((key, value) =>
          MapEntry(key, jsonDecode(value) as Map<String, dynamic>))
      .values
      .toList();
}

List<String> toStringList(List<Map<String, dynamic>> list) {
  return List.from(list)
      .asMap()
      .map((key, value) => MapEntry(key, jsonEncode(value)))
      .values
      .toList();
}
