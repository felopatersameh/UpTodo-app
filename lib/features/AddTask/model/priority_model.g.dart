// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriorityModelAdapter extends TypeAdapter<PriorityModel> {
  @override
  final int typeId = 4;

  @override
  PriorityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriorityModel(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PriorityModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
