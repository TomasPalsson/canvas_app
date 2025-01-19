// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoadingWidgetAdapter extends TypeAdapter<LoadingWidget> {
  @override
  final int typeId = 40;

  @override
  LoadingWidget read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LoadingWidget.newtonCradle;
      case 1:
        return LoadingWidget.inkDrop;
      case 2:
        return LoadingWidget.halfTriangleDot;
      case 3:
        return LoadingWidget.waveDots;
      case 4:
        return LoadingWidget.staggeredDotsWave;
      case 5:
        return LoadingWidget.threeRotatingDots;
      default:
        return LoadingWidget.newtonCradle;
    }
  }

  @override
  void write(BinaryWriter writer, LoadingWidget obj) {
    switch (obj) {
      case LoadingWidget.newtonCradle:
        writer.writeByte(0);
        break;
      case LoadingWidget.inkDrop:
        writer.writeByte(1);
        break;
      case LoadingWidget.halfTriangleDot:
        writer.writeByte(2);
        break;
      case LoadingWidget.waveDots:
        writer.writeByte(3);
        break;
      case LoadingWidget.staggeredDotsWave:
        writer.writeByte(4);
        break;
      case LoadingWidget.threeRotatingDots:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingWidgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
