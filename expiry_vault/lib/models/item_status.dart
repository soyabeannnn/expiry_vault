import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ItemStatus { fresh, expiringSoon, expired }

extension ItemStatusX on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.fresh: return 'Fresh';
      case ItemStatus.expiringSoon: return 'Expiring soon';
      case ItemStatus.expired: return 'Expired';
    }
  }

  Color get color {
    switch (this) {
      case ItemStatus.fresh: return AppColors.freshGreen;
      case ItemStatus.expiringSoon: return AppColors.sunshineYellow;
      case ItemStatus.expired: return AppColors.tomatoRed;
    }
  }

  Color get textColor {
    switch (this) {
      case ItemStatus.fresh: return AppColors.freshText;
      case ItemStatus.expiringSoon: return AppColors.expiringText;
      case ItemStatus.expired: return AppColors.expiredText;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ItemStatus.fresh: return AppColors.freshBg;
      case ItemStatus.expiringSoon: return AppColors.expiringBg;
      case ItemStatus.expired: return AppColors.expiredBg;
    }
  }

  IconData get icon {
    switch (this) {
      case ItemStatus.fresh: return Icons.circle;
      case ItemStatus.expiringSoon: return Icons.contrast_rounded;
      case ItemStatus.expired: return Icons.circle_outlined;
    }
  }
}