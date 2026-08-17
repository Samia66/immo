import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_model.freezed.dart';
part 'owner_model.g.dart';

/// A property summary nested inside [OwnerModel.properties] - only present on
/// the `GET /owners/:id` detail response (`OwnersService.findOne`), never on
/// the `GET /owners` list response.
@freezed
class OwnerPropertySummaryModel with _$OwnerPropertySummaryModel {
  const factory OwnerPropertySummaryModel({
    required String id,
    required String reference,
    required String title,
    required int unitsCount,
  }) = _OwnerPropertySummaryModel;

  factory OwnerPropertySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerPropertySummaryModelFromJson(json);
}

/// Owner contact info, fetched via `GET /owners` (list) and `GET /owners/:id`
/// (detail - `OwnersMapper.toResponse`). `propertiesCount`/`totalRevenue`/
/// `properties` are only populated by the detail endpoint; the list endpoint
/// leaves them null.
@freezed
class OwnerModel with _$OwnerModel {
  const factory OwnerModel({
    required String id,
    required String fullName,
    required String phone,
    String? email,
    String? address,
    String? userId,
    int? propertiesCount,
    num? totalRevenue,
    List<OwnerPropertySummaryModel>? properties,
    DateTime? createdAt,
  }) = _OwnerModel;

  factory OwnerModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerModelFromJson(json);
}
