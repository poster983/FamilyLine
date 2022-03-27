
class APIException implements Exception {
  String message;
  int statusCode;

  APIException({required this.message, required this.statusCode});
}