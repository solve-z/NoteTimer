import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 3)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime assignedDate;

  @HiveField(4)
  final String noteId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  @HiveField(7)
  final String userId;

  @HiveField(8)
  final int sortOrder;

  TodoModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.assignedDate,
    required this.noteId,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.sortOrder = 0,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? assignedDate,
    String? noteId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    int? sortOrder,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedDate: assignedDate ?? this.assignedDate,
      noteId: noteId ?? this.noteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}