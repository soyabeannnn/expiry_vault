// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemCategoryAdapter extends TypeAdapter<ItemCategory> {
  @override
  final int typeId = 1;

  @override
  ItemCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemCategory.produce;
      case 1:
        return ItemCategory.dairy;
      case 2:
        return ItemCategory.pantry;
      case 3:
        return ItemCategory.medicine;
      case 4:
        return ItemCategory.cosmetics;
      case 5:
        return ItemCategory.frozen;
      default:
        return ItemCategory.produce;
    }
  }

  @override
  void write(BinaryWriter writer, ItemCategory obj) {
    switch (obj) {
      case ItemCategory.produce:
        writer.writeByte(0);
        break;
      case ItemCategory.dairy:
        writer.writeByte(1);
        break;
      case ItemCategory.pantry:
        writer.writeByte(2);
        break;
      case ItemCategory.medicine:
        writer.writeByte(3);
        break;
      case ItemCategory.cosmetics:
        writer.writeByte(4);
        break;
      case ItemCategory.frozen:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
