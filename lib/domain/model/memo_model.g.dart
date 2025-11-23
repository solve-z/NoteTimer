// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoModelAdapter extends TypeAdapter<MemoModel> {
  @override
  final int typeId = 4;

  @override
  MemoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoModel(
      id: fields[0] as String,
      content: fields[1] as String,
      assignedDate: fields[2] as DateTime,
      noteId: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime?,
      userId: fields[6] as String,
      sortOrder: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MemoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.assignedDate)
      ..writeByte(3)
      ..write(obj.noteId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
