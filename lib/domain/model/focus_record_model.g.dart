// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FocusRecordModelAdapter extends TypeAdapter<FocusRecordModel> {
  @override
  final int typeId = 2;

  @override
  FocusRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusRecordModel(
      id: fields[0] as String,
      noteId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      duration: fields[4] as int,
      userId: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FocusRecordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.noteId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
