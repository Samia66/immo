import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/property_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../providers/agent_providers.dart';

class NewVisitScreen extends ConsumerStatefulWidget {
  const NewVisitScreen({super.key, this.initialPropertyId});

  final String? initialPropertyId;

  @override
  ConsumerState<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends ConsumerState<NewVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedPropertyId;
  String? _selectedPropertyTitle;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPropertyId = widget.initialPropertyId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickProperty() async {
    final selected = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _PropertyPickerSheet(),
    );
    if (selected != null) {
      setState(() {
        _selectedPropertyId = selected['id'];
        _selectedPropertyTitle = selected['title'];
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPropertyId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Veuillez sélectionner un bien.')));
      return;
    }
    setState(() => _submitting = true);
    final scheduledAt =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    try {
      final visit = await ref.read(visitsRepositoryProvider).create(
            propertyId: _selectedPropertyId!,
            clientName: _nameController.text.trim(),
            clientPhone: _phoneController.text.trim(),
            clientEmail: _emailController.text.trim(),
            scheduledAt: scheduledAt,
            notes: _notesController.text.trim(),
          );
      ref.read(visitsListProvider.notifier).refresh();
      if (!mounted) return;
      context.pushReplacement(AppRoutes.agentVisitDetailPath(visit.id));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planifier une visite')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: _pickProperty,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Bien concerné'),
                child: Text(
                  _selectedPropertyTitle ??
                      (_selectedPropertyId != null ? _selectedPropertyId! : 'Choisir un bien'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du client'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Nom requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Téléphone (facultatif)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email (facultatif)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(Formatters.date(_date)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_time.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (facultatif)'),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Text('Planifier'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyPickerSheet extends ConsumerStatefulWidget {
  const _PropertyPickerSheet();

  @override
  ConsumerState<_PropertyPickerSheet> createState() => _PropertyPickerSheetState();
}

class _PropertyPickerSheetState extends ConsumerState<_PropertyPickerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(propertiesListProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Rechercher un bien...',
                  isDense: true,
                ),
                onSubmitted: (value) => ref
                    .read(propertiesListProvider.notifier)
                    .applyFilter(ref.read(propertiesListProvider.notifier).filter.copyWith(search: value)),
              ),
            ),
            Expanded(
              child: listState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('$error')),
                data: (items) => ListView.builder(
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final property = items[index];
                    return ListTile(
                      leading: CachedThumb(
                        relativeUrl: property.coverImage?.url,
                        width: 44,
                        height: 44,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(property.city),
                      onTap: () => Navigator.of(context)
                          .pop({'id': property.id, 'title': property.title}),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
