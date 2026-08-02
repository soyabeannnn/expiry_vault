import 'package:flutter/material.dart';

import '../models/item_category.dart';

/// Colored rounded-square + emoji, matching the brand board's "Category
/// icon set". Reused for the Home shelves grid and category pickers.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.size = 48,
    this.selected = false,
  });

  final ItemCategory category;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: selected ? Border.all(color: Colors.white, width: 3) : null,
        boxShadow: selected
            ? [BoxShadow(color: category.color.withValues(alpha: 0.6), blurRadius: 8)]
            : null,
      ),
      child: Text(category.emoji, style: TextStyle(fontSize: size * 0.46)),
    );
  }
}
