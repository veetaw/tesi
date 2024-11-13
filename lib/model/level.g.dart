// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 2;

  @override
  Level read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      livello: fields[0] as int?,
      openQuestions: (fields[1] as List?)?.cast<String>(),
      multipleChoice: (fields[2] as List?)?.cast<MultipleChoice>(),
    )
      ..isNext = fields[3] as bool
      ..isDone = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.livello)
      ..writeByte(1)
      ..write(obj.openQuestions)
      ..writeByte(2)
      ..write(obj.multipleChoice)
      ..writeByte(3)
      ..write(obj.isNext)
      ..writeByte(4)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
