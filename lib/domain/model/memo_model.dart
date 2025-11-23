import 'package:hive/hive.dart';

part 'memo_model.g.dart';

@HiveType(typeId: 4)
class MemoModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime assignedDate;

  @HiveField(3)
  final String noteId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final int sortOrder;

  MemoModel({
    required this.id,
    required this.content,
    required this.assignedDate,
    required this.noteId,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.sortOrder = 0,
  });

  MemoModel copyWith({
    String? id,
    String? content,
    DateTime? assignedDate,
    String? noteId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    int? sortOrder,
  }) {
    return MemoModel(
      id: id ?? this.id,
      content: content ?? this.content,
      assignedDate: assignedDate ?? this.assignedDate,
      noteId: noteId ?? this.noteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
