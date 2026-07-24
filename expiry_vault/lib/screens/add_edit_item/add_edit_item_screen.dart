import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/pantry_item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/constants.dart';
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
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;

  late ItemCategory _category;
  late DateTime _expiryDate;
  DateTime? _purchaseDate;

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.editingItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(text: (item?.quantity ?? 1).toString());
    _unitController = TextEditingController(text: item?.unit ?? '');
    _category = item?.category ?? widget.initialCategory ?? ItemCategory.produce;
    _expiryDate = item?.expiryDate ?? DateTime.now().add(const Duration(days: 7));
    _purchaseDate = item?.purchaseDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isExpiry}) async {
    final initial = isExpiry ? _expiryDate : (_purchaseDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isExpiry) {
        _expiryDate = picked;
      } else {
        _purchaseDate = picked;
      }
    });
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
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final parsed = double.tryParse((value ?? '').trim());
                      if (parsed == null || parsed <= 0) return 'Enter a valid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unit (e.g. pcs, g, ml)'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Enter a unit' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AppConstants.commonUnits
                  .map((unit) => ActionChip(
                        label: Text(unit),
                        onPressed: () => setState(() => _unitController.text = unit),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            _DateField(
              label: 'Expiry date',
              date: _expiryDate,
              onTap: () => _pickDate(isExpiry: true),
              required: true,
            ),
            const SizedBox(height: 12),
            _DateField(
              label: 'Purchase date (optional)',
              date: _purchaseDate,
              onTap: () => _pickDate(isExpiry: false),
              onClear: _purchaseDate == null ? null : () => setState(() => _purchaseDate = null),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
    this.required = false,
    this.onClear,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool required;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onClear != null
              ? IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClear)
              : const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          date == null
              ? 'Select a date'
              : '${date!.day}/${date!.month}/${date!.year}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

