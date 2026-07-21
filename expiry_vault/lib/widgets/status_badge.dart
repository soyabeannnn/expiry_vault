import 'package:flutter/material.dart';

import '../models/item_status.dart';

/// Shape + color status chip, e.g. used on item tiles and the detail screen.
/// Never relies on color alone (accessibility rule from the brand brief).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.compact = false});

  final ItemStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 4 : 6),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: compact ? 10 : 12, color: status.color),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: status.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
