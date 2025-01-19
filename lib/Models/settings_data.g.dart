// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final int typeId = 41;

  @override
  SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsData(
      isDarkMode: fields[0] as bool,
      loadingWidget: fields[1] as LoadingWidget,
      canvasToken: fields[2] as String?,
      canvasBaseUrl: fields[3] as String?,
      geminiApiKey: fields[4] as String?,
      openAiApiKey: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.loadingWidget)
      ..writeByte(2)
      ..write(obj.canvasToken)
      ..writeByte(3)
      ..write(obj.canvasBaseUrl)
      ..writeByte(4)
      ..write(obj.geminiApiKey)
      ..writeByte(5)
      ..write(obj.openAiApiKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
