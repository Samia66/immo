import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/photo_picker_widget.dart';
import '../providers/manager_providers.dart';

class MaintenanceCompletionScreen extends ConsumerStatefulWidget {
  const MaintenanceCompletionScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<MaintenanceCompletionScreen> createState() =>
      _MaintenanceCompletionScreenState();
}

class _MaintenanceCompletionScreenState extends ConsumerState<MaintenanceCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  List<XFile> _afterPhotos = [];
  bool _submitting = false;

  @override
  void dispose() {
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final repo = ref.read(managerMaintenanceRepositoryProvider);
    try {
      if (_afterPhotos.isNotEmpty) {
        await repo.uploadAttachments(
          requestId: widget.requestId,
          files: _afterPhotos,
          phase: AttachmentPhase.APRES,
        );
      }
      final rawCost = _costController.text.trim();
      await repo.updateStatus(
        id: widget.requestId,
        status: MaintenanceStatus.TERMINEE,
        actualCost: rawCost.isEmpty ? null : num.tryParse(rawCost),
      );
      ref.invalidate(managerMaintenanceDetailProvider(widget.requestId));
      ref.read(assignedMaintenanceProvider.notifier).refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Intervention terminée.')));
      Navigator.of(context)
        ..pop()
        ..pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(managerMaintenanceDetailProvider(widget.requestId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Terminer l'intervention")),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(message: error.toString()),
        data: (request) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.category, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(request.description, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Photos après intervention', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              PhotoPickerWidget(
                photos: _afterPhotos,
                onChanged: (photos) => setState(() => _afterPhotos = photos),
                label: 'Photos "après"',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Coût réel (facultatif)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  if (num.tryParse(value.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes finales (aide-mémoire local)',
                  helperText: "Non envoyées au serveur - l'API ne stocke pas de notes techniques sur la demande.",
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _submitting ? null : _confirm,
                icon: _submitting
                    ? const SizedBox(
                        width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check_circle_outline),
                label: const Text('Confirmer la fin des travaux'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
