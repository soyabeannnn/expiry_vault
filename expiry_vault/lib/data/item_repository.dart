import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/item_category.dart';
import '../models/pantry_item.dart';
import '../services/hive_service.dart';

class ItemRepository {
  ItemRepository({Box<PantryItem>? box}) : _box = box ?? HiveService.itemsBox;

  final Box<PantryItem> _box;
  final Uuid _uuid = const Uuid();

  List<PantryItem> getAll() => _box.values.toList(growable: false);

  PantryItem? getById(String id) {
    try {
      return _box.values.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<PantryItem> create({
    required String name,
    required ItemCategory category,
    required double quantity,
    required String unit,
    required DateTime expiryDate,
    DateTime? purchaseDate,
    String? photoPath,
    String? notes,
  }) async {
    final item = PantryItem(
      id: _uuid.v4(),
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      photoPath: photoPath,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _box.put(item.id, item);
    return item;
  }

  Future<void> update(PantryItem item) async {
    // Use put() rather than item.save(): `item` may be a plain PantryItem
    // built via copyWith() that was never attached to this box (save()
    // requires HiveObject.isInBox and throws otherwise). put() writes it
    // under the same key the item was originally created with and attaches
    // it to the box either way.
    await _box.put(item.id, item);
  }

  Future<void> delete(PantryItem item) async {
    await item.delete();
  }
}
