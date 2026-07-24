import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/item_category.dart';
import '../../models/pantry_item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
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
  late final TextEditingController _notesController;

  late ItemCategory _category;
  late DateTime _expiryDate;
  DateTime? _purchaseDate;
  String? _photoPath;
  bool _saving = false;

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.editingItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(text: (item?.quantity ?? 1).toString());
    _unitController = TextEditingController(text: item?.unit ?? '');
    _notesController = TextEditingController(text: item?.notes ?? '');
    _category = item?.category ?? widget.initialCategory ?? ItemCategory.produce;
    _expiryDate = item?.expiryDate ?? DateTime.now().add(const Duration(days: 7));
    _purchaseDate = item?.purchaseDate;
    _photoPath = item?.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _notesController.dispose();
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

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    setState(() => _photoPath = picked.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final itemProvider = context.read<ItemProvider>();
    final leadDays = context.read<SettingsProvider>().reminderLeadDays;
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1;

    try {
      if (_isEditing) {
        final updated = widget.editingItem!.copyWith(
          name: _nameController.text.trim(),
          category: _category,
          quantity: quantity,
          unit: _unitController.text.trim(),
          expiryDate: _expiryDate,
          purchaseDate: _purchaseDate,
          clearPurchaseDate: _purchaseDate == null,
          photoPath: _photoPath,
          clearPhoto: _photoPath == null,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          clearNotes: _notesController.text.trim().isEmpty,
        );
        await itemProvider.updateItem(updated, reminderLeadDays: leadDays);
      } else {
        await itemProvider.addItem(
          name: _nameController.text.trim(),
          category: _category,
          quantity: quantity,
          unit: _unitController.text.trim(),
          expiryDate: _expiryDate,
          purchaseDate: _purchaseDate,
          photoPath: _photoPath,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          reminderLeadDays: leadDays,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
            Center(child: _PhotoPicker(photoPath: _photoPath, category: _category, onTap: _pickPhoto)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item name'),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Please enter a name' : null,
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isEditing ? 'Save changes' : 'Add to vault'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.photoPath, required this.category, required this.onTap});

  final String? photoPath;
  final ItemCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: category.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: photoPath != null
            ? Image.file(File(photoPath!), fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  const Icon(Icons.add_a_photo_outlined, size: 16, color: AppColors.neutralGrey),
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

