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
}