import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_model.freezed.dart';
part 'owner_model.g.dart';

/// Minimal owner contact info, fetched via `GET /owners/:id` for the agent's
/// "owner contact" section on a property's detail screen.
@freezed
class OwnerModel with _$OwnerModel {
  const factory OwnerModel({
    required String id,
    required String fullName,
    required String phone,
    String? email,
    String? address,
  }) = _OwnerModel;

  factory OwnerModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerModelFromJson(json);
}
