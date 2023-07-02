import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Knowby with _$Knowby {
  const factory Knowby({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String name,
  }) = _Knowby;

  factory Knowby.fromJson(Map<String, dynamic> json) => _$KnowbyFromJson(json);
}
