import 'package:json_annotation/json_annotation.dart';
part 'APIPagination.g.dart';

// "totalDocs": 886,
//   "offset": 0,
//   "limit": 10,
//   "totalPages": 89,
//   "page": 1,
//   "pagingCounter": 1,
//   "hasPrevPage": false,
//   "hasNextPage": true,
//   "prevPage": null,
//   "nextPage": 2
// "docs": []

@JsonSerializable(genericArgumentFactories: true)
class APIPagination < T > {
  APIPagination({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.offset,
    this.prevPage,
    this.nextPage,
  });
  final List < T > docs;
  final int totalDocs;
  final int? offset;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;



  factory APIPagination.fromJson(
    Map < String, dynamic > json,
    T Function(Object ? json) fromJsonT,
  ) =>
  _$APIPaginationFromJson(json, fromJsonT);
  Map < String,
  dynamic > toJson(Object Function(T value) toJsonT) =>
  _$APIPaginationToJson(this, toJsonT);

}