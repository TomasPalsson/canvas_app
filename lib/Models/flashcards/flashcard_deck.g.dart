// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardDeckImplAdapter extends TypeAdapter<_$FlashcardDeckImpl> {
  @override
  final int typeId = 8;

  @override
  _$FlashcardDeckImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$FlashcardDeckImpl(
      id: fields[0] as String,
      courseId: fields[1] as String,
      title: fields[2] as String,
      cards: (fields[3] as List).cast<Flashcard>(),
      createdAt: fields[4] as DateTime,
      totalReviews: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, _$FlashcardDeckImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.totalReviews)
      ..writeByte(3)
      ..write(obj.cards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardDeckImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlashcardDeckImpl _$$FlashcardDeckImplFromJson(Map<String, dynamic> json) =>
    _$FlashcardDeckImpl(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FlashcardDeckImplToJson(_$FlashcardDeckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'cards': instance.cards,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalReviews': instance.totalReviews,
    };
