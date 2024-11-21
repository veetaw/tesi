// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OpenQuestionAdapter extends TypeAdapter<OpenQuestion> {
  @override
  final int typeId = 4;

  @override
  OpenQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OpenQuestion(
      domanda: fields[0] as String?,
      suggerimento: fields[1] as String?,
    )..voto = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, OpenQuestion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.domanda)
      ..writeByte(1)
      ..write(obj.suggerimento)
      ..writeByte(2)
      ..write(obj.voto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
