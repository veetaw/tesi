// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_choice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MultipleChoiceAdapter extends TypeAdapter<MultipleChoice> {
  @override
  final int typeId = 3;

  @override
  MultipleChoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultipleChoice(
      question: fields[0] as String?,
      answers: (fields[1] as List?)?.cast<String>(),
      correctIndex: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MultipleChoice obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answers)
      ..writeByte(2)
      ..write(obj.correctIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
