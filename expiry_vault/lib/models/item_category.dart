import 'package:hive/hive.dart';

part 'item_category.g.dart';

@HiveType(typeId: 1)
enum ItemCategory {
  @HiveField(0)
  produce,
  @HiveField(1)
  dairy,
  @HiveField(2)
  pantry,
  @HiveField(3)
  medicine,
  @HiveField(4)
  cosmetics,
  @HiveField(5)
  frozen,
}