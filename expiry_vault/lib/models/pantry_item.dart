import 'package:hive/hive.dart';
import 'item_category.dart';
import 'item_status.dart';
import '../services/item_status_service.dart';

part 'pantry_item.g.dart';

@HiveType(typeId: 0)
class PantryItem extends HiveObject {
  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.createdAt,
    this.purchaseDate,
    this.photoPath,
    this.notes,
    this.scheduledNotificationId,
  });

  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) ItemCategory category;
  @HiveField(3) double quantity;
  @HiveField(4) String unit;
  @HiveField(5) DateTime expiryDate;
  @HiveField(6) DateTime? purchaseDate;
  @HiveField(7) String? photoPath;
  @HiveField(8) String? notes;
  @HiveField(9) DateTime createdAt;
  @HiveField(10) int? scheduledNotificationId;

  ItemStatus statusFor(int thresholdDays) =>
      ItemStatusService.computeStatus(expiryDate, thresholdDays);
  PantryItem copyWith({
    String? name,
    ItemCategory? category,
    double? quantity,
    String? unit,
    DateTime? expiryDate,
    DateTime? purchaseDate,
    String? photoPath,
    String? notes,
    int? scheduledNotificationId,
    bool clearPhoto = false,
    bool clearNotes = false,
    bool clearPurchaseDate = false,
  }) {
    return PantryItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt,
      purchaseDate: clearPurchaseDate ? null : (purchaseDate ?? this.purchaseDate),
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      notes: clearNotes ? null : (notes ?? this.notes),
      scheduledNotificationId: scheduledNotificationId ?? this.scheduledNotificationId,
    );
  }
}