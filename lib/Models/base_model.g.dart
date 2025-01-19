// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseModelAdapter extends TypeAdapter<BaseModel> {
  @override
  final int typeId = 0;

  @override
  BaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseModel(
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BaseModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
