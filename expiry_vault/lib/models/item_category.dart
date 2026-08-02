import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

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

extension ItemCategoryX on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.produce: return 'Produce';
      case ItemCategory.dairy: return 'Dairy & Fridge';
      case ItemCategory.pantry: return 'Pantry';
      case ItemCategory.medicine: return 'Medicine';
      case ItemCategory.cosmetics: return 'Cosmetics';
      case ItemCategory.frozen: return 'Frozen';
    }
  }

  String get emoji {
    switch (this) {
      case ItemCategory.produce: return '🥬';
      case ItemCategory.dairy: return '🥛';
      case ItemCategory.pantry: return '🥫';
      case ItemCategory.medicine: return '💊';
      case ItemCategory.cosmetics: return '🧴';
      case ItemCategory.frozen: return '🧊';
    }
  }

  Color get color {
    switch (this) {
      case ItemCategory.produce: return AppColors.freshGreen;
      case ItemCategory.dairy: return AppColors.vaultBlue;
      case ItemCategory.pantry: return AppColors.peach;
      case ItemCategory.medicine: return AppColors.grapePurple;
      case ItemCategory.cosmetics: return AppColors.tomatoRed;
      case ItemCategory.frozen: return AppColors.sunshineYellow;
    }
  }

  Color get onColor {
    switch (this) {
      case ItemCategory.frozen: return AppColors.charcoal;
      default: return Colors.white;
    }
  }
}