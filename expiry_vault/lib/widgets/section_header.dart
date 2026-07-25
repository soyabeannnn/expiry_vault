import 'package:flutter/material.dart';

/// Consistent "Title + optional trailing action" header used across the
/// dashboard and list screens (mirrors the brand board's section labels).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          // ignore: use_null_aware_elements — kept for hive_generator's older bundled analyzer
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
