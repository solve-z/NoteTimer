import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? nickname;

  @HiveField(3)
  final String? profileImageUrl;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.nickname,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}