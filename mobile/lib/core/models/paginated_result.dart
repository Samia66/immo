import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result.freezed.dart';
part 'paginated_result.g.dart';

@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

/// Generic pagination envelope matching `{ data: T[], meta: {...} }` returned
/// by every list endpoint.
@Freezed(genericArgumentFactories: true)
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> data,
    required PaginationMeta meta,
  }) = _PaginatedResult<T>;

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResultFromJson(json, fromJsonT);
}
