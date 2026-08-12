import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/photo_picker_widget.dart';
import '../providers/tenant_providers.dart';

const _categories = [
  'Plomberie',
  'Électricité',
  'Chauffage / Climatisation',
  'Serrurerie',
  'Peinture / Revêtements',
  'Électroménager',
  'Autre',
];

class NewMaintenanceScreen extends ConsumerStatefulWidget {
  const NewMaintenanceScreen({super.key});

  @override
  ConsumerState<NewMaintenanceScreen> createState() => _NewMaintenanceScreenState();
}

class _NewMaintenanceScreenState extends ConsumerState<NewMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _category = _categories.first;
  MaintenancePriority _priority = MaintenancePriority.NORMALE;
  List<XFile> _photos = [];
  bool _submitting = false;
  bool _taggingLocation = false;
  Position? _position;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _tagLocation() async {
    setState(() => _taggingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission de localisation refusée.')),
        );
        return;
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le service de localisation est désactivé.')),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() => _position = position);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'obtenir la position actuelle.")),
      );
    } finally {
      if (mounted) setState(() => _taggingLocation = false);
    }
  }

  Future<void> _submit(String propertyId) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      var description = _descriptionController.text.trim();
      if (_position != null) {
        description =
            '$description\n\n[Position signalée : ${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}]';
      }
      final repo = ref.read(tenantMaintenanceRepositoryProvider);
      final created = await repo.create(
        propertyId: propertyId,
        category: _category,
        description: description,
        priority: _priority,
      );
      if (_photos.isNotEmpty) {
        await repo.uploadAttachments(
          requestId: created.id,
          files: _photos,
          phase: AttachmentPhase.AVANT,
        );
      }
      ref.read(tenantMaintenanceProvider.notifier).refresh();
      if (!mounted) return;
      context.pushReplacement(AppRoutes.tenantMaintenanceDetailPath(created.id));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur est survenue.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(tenantDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle demande')),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const EmptyStateView(
          icon: Icons.error_outline,
          title: 'Impossible de charger votre bail',
        ),
        data: (dashboard) {
          final propertyId = dashboard.activeLease?.property.id;
          if (propertyId == null) {
            return const EmptyStateView(
              icon: Icons.home_work_outlined,
              title: 'Aucun bail actif',
              message: "Vous devez avoir un bail actif pour créer une demande de maintenance.",
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                  items: [
                    for (final c in _categories) DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (value) => setState(() => _category = value ?? _category),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    hintText: 'Décrivez le problème rencontré...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return 'Merci de décrire le problème (5 caractères min.)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Priorité', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in MaintenancePriority.values)
                      ChoiceChip(
                        label: Text(p.label),
                        selected: _priority == p,
                        onSelected: (_) => setState(() => _priority = p),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                PhotoPickerWidget(
                  photos: _photos,
                  onChanged: (photos) => setState(() => _photos = photos),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _taggingLocation ? null : _tagLocation,
                  icon: _taggingLocation
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(_position != null ? Icons.location_on : Icons.location_on_outlined),
                  label: Text(_position != null
                      ? 'Position ajoutée (${_position!.latitude.toStringAsFixed(3)}, ${_position!.longitude.toStringAsFixed(3)})'
                      : 'Ajouter ma position actuelle (facultatif)'),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _submitting ? null : () => _submit(propertyId),
                  child: _submitting
                      ? const SizedBox(
                          width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Text('Envoyer la demande'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
