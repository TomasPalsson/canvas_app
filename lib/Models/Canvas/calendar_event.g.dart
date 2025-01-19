// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarEventAdapter extends TypeAdapter<CalendarEvent> {
  @override
  final int typeId = 100;

  @override
  CalendarEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEvent(
      id: fields[0] as String,
      title: fields[100] as String,
      startAt: fields[101] as DateTime,
      endAt: fields[102] as DateTime,
      description: fields[104] as String,
      locationName: fields[105] as String,
      locationAddress: fields[106] as String,
      contextCode: fields[107] as String,
      contextName: fields[108] as String,
      hidden: fields[103] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarEvent obj) {
    writer
      ..writeByte(10)
      ..writeByte(100)
      ..write(obj.title)
      ..writeByte(101)
      ..write(obj.startAt)
      ..writeByte(102)
      ..write(obj.endAt)
      ..writeByte(103)
      ..write(obj.hidden)
      ..writeByte(104)
      ..write(obj.description)
      ..writeByte(105)
      ..write(obj.locationName)
      ..writeByte(106)
      ..write(obj.locationAddress)
      ..writeByte(107)
      ..write(obj.contextCode)
      ..writeByte(108)
      ..write(obj.contextName)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
