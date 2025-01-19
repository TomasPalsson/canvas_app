// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleAdapter extends TypeAdapter<Module> {
  @override
  final int typeId = 120;

  @override
  Module read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Module(
      id: fields[0] as String,
      name: fields[120] as String,
      itemsUrl: fields[121] as String,
      items: (fields[122] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Module obj) {
    writer
      ..writeByte(4)
      ..writeByte(120)
      ..write(obj.name)
      ..writeByte(121)
      ..write(obj.itemsUrl)
      ..writeByte(122)
      ..write(obj.items)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
