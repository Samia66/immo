import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_model.freezed.dart';
part 'worker_model.g.dart';

/// An entry in the manager's worker/contractor address book (plumber,
/// electrician, locksmith, ...) - `GET /workers`, `GET /workers/me`
/// (WorkersMapper.toResponse). `propertyId` null means the worker is
/// "general" and visible across every property, not tied to one building.
@freezed
class WorkerModel with _$WorkerModel {
  const factory WorkerModel({
    required String id,
    required String organizationId,
    required String fullName,
    required String trade,
    required String phone,
    String? email,
    String? notes,
    required bool isActive,
    String? propertyId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkerModel;

  factory WorkerModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerModelFromJson(json);
}
