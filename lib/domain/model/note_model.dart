import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int colorValue;

  @HiveField(3)
  final bool isPinned;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final bool isArchived;

  @HiveField(8)
  final bool isSelectedForToday;

  @HiveField(9)
  final int sortOrder;

  NoteModel({
    required this.id,
    required this.title,
    required this.colorValue,
    this.isPinned = false,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.isArchived = false,
    this.isSelectedForToday = false,
    this.sortOrder = 0,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    int? colorValue,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isArchived,
    bool? isSelectedForToday,
    int? sortOrder,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isArchived: isArchived ?? this.isArchived,
      isSelectedForToday: isSelectedForToday ?? this.isSelectedForToday,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}