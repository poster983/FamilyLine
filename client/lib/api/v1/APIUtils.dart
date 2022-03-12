

String queryFromMap(Map<String, dynamic> map) {
  final String _queryString = Uri(
      queryParameters:
          map.map((key, value) => MapEntry(key, value?.toString()))).query;
  return _queryString;
}