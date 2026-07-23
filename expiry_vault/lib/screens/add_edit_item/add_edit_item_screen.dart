import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/pantry_item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/category_tile.dart';

/// Single form that handles both Create and Update — pass an existing
/// [editingItem] to switch into edit mode (pre-filled fields, "Save
/// changes" button, and an `updateItem` call instead of `addItem`).
class AddEditItemScreen extends StatefulWidget {
  const AddEditItemScreen({super.key, this.editingItem, this.initialCategory});

  final PantryItem? editingItem;
  final ItemCategory? initialCategory;

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late ItemCategory _category;
  late DateTime _expiryDate;

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.editingItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _category = item?.category ?? widget.initialCategory ?? ItemCategory.produce;
    _expiryDate = item?.expiryDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit item' : 'Add item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item name'),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            Text('Category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ItemCategory.values.map((category) {
                final selected = category == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = category),
                  child: Column(
                    children: [
                      CategoryTile(category: category, size: 52, selected: selected),
                      const SizedBox(height: 4),
                      Text(
                        category.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
