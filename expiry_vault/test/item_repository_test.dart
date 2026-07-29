import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pantry_pal/data/item_repository.dart';
import 'package:pantry_pal/models/item_category.dart';
import 'package:pantry_pal/models/pantry_item.dart';

void main() {
  late Directory tempDir;
  late Box<PantryItem> box;
  late ItemRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('expiryvault_hive_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PantryItemAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ItemCategoryAdapter());
    box = await Hive.openBox<PantryItem>('test_items');
    repository = ItemRepository(box: box);
  });

  tearDown(() async {
    await box.deleteFromDisk();
    await Hive.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  test('create() persists a new item to disk', () async {
    final created = await repository.create(
      name: 'Milk',
      category: ItemCategory.dairy,
      quantity: 1,
      unit: 'L',
      expiryDate: DateTime(2026, 7, 20),
    );

    expect(repository.getById(created.id)?.name, 'Milk');
  });