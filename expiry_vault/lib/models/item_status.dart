import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Derived, never persisted — always recomputed from an item's expiry date
/// so it's impossible for stored data and displayed status to drift apart.
enum ItemStatus { fresh, expiringSoon, expired }

extension ItemStatusX on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.fresh:
        return 'Fresh';
      case ItemStatus.expiringSoon:
        return 'Expiring soon';
      case ItemStatus.expired:
        return 'Expired';
    }
  }

  Color get color {
    switch (this) {
      case ItemStatus.fresh:
        return AppColors.freshGreen;
      case ItemStatus.expiringSoon:
        return AppColors.sunshineYellow;
      case ItemStatus.expired:
        return AppColors.tomatoRed;
    }
  }

  Color get textColor {
    switch (this) {
      case ItemStatus.fresh:
        return AppColors.freshText;
      case ItemStatus.expiringSoon:
        return AppColors.expiringText;
      case ItemStatus.expired:
        return AppColors.expiredText;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ItemStatus.fresh:
        return AppColors.freshBg;
      case ItemStatus.expiringSoon:
        return AppColors.expiringBg;
      case ItemStatus.expired:
        return AppColors.expiredBg;
    }
  }

  /// Status is conveyed by shape *and* color (accessibility rule from the
  /// brand brief): filled dot / half-filled dot / crossed-out dot.
  IconData get icon {
    switch (this) {
      case ItemStatus.fresh:
        return Icons.circle;
      case ItemStatus.expiringSoon:
        return Icons.contrast_rounded;
      case ItemStatus.expired:
        return Icons.circle_outlined;
    }
  }
}
