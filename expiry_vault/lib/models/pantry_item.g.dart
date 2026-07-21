// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PantryItemAdapter extends TypeAdapter<PantryItem> {
  @override
  final int typeId = 0;

  @override
  PantryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PantryItem(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as ItemCategory,
      quantity: fields[3] as double,
      unit: fields[4] as String,
      expiryDate: fields[5] as DateTime,
      createdAt: fields[9] as DateTime,
      purchaseDate: fields[6] as DateTime?,
      photoPath: fields[7] as String?,
      notes: fields[8] as String?,
      scheduledNotificationId: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PantryItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.photoPath)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.scheduledNotificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PantryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
