import 'package:hive/hive.dart';

part 'focus_record_model.g.dart';

@HiveType(typeId: 2)
class FocusRecordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String noteId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final int duration;

  @HiveField(5)
  final String userId;

  @HiveField(6)
  final DateTime createdAt;

  FocusRecordModel({
    required this.id,
    required this.noteId,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.userId,
    required this.createdAt,
  });

  FocusRecordModel copyWith({
    String? id,
    String? noteId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? userId,
    DateTime? createdAt,
  }) {
    return FocusRecordModel(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}