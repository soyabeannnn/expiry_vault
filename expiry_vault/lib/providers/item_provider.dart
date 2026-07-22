import 'package:flutter/foundation.dart';
import '../data/item_repository.dart';
import '../models/item_category.dart';
import '../models/pantry_item.dart';
import '../services/notification_service.dart';

class ItemProvider extends ChangeNotifier {
  ItemProvider({ItemRepository? repository}) : _repository = repository ?? ItemRepository() {
    _items = _repository.getAll();
  }

  final ItemRepository _repository;
  late List<PantryItem> _items;

  List<PantryItem> get items => List.unmodifiable(_items);

  int countForCategory(ItemCategory category) =>
      _items.where((item) => item.category == category).length;

  Future<PantryItem> addItem({
    required String name,
    required ItemCategory category,
    required double quantity,
    required String unit,
    required DateTime expiryDate,
    DateTime? purchaseDate,
    String? photoPath,
    String? notes,
    required int reminderLeadDays,
  }) async {
    final item = await _repository.create(
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      purchaseDate: purchaseDate,
      photoPath: photoPath,
      notes: notes,
    );

    final notificationId =
    await NotificationService.instance.scheduleForItem(item, reminderLeadDays);
    item.scheduledNotificationId = notificationId;
    await _repository.update(item);

    _items = _repository.getAll();
    notifyListeners();
    return item;
  }

  Future<void> updateItem(PantryItem updated, {required int reminderLeadDays}) async {
    await NotificationService.instance.cancelForItem(updated);
    final notificationId =
    await NotificationService.instance.scheduleForItem(updated, reminderLeadDays);
    updated.scheduledNotificationId = notificationId;
    await _repository.update(updated);

    _items = _repository.getAll();
    notifyListeners();
  }

  Future<void> deleteItem(PantryItem item) async {
    await NotificationService.instance.cancelForItem(item);
    await _repository.delete(item);

    _items = _repository.getAll();
    notifyListeners();
  }
}