import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/photo_picker_widget.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/manager_providers.dart';

/// Property/tenant info, "start intervention" (ASSIGNEE → EN_COURS), and
/// before-photo capture. The mobile field-manager flow only drives
/// ASSIGNEE→EN_COURS here and EN_COURS→TERMINEE on the completion screen -
/// the rest of the maintenance state machine is office-side.
class MaintenanceInterventionScreen extends ConsumerStatefulWidget {
  const MaintenanceInterventionScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<MaintenanceInterventionScreen> createState() =>
      _MaintenanceInterventionScreenState();
}

class _MaintenanceInterventionScreenState extends ConsumerState<MaintenanceInterventionScreen> {
  final _notesController = TextEditingController();
  List<XFile> _beforePhotos = [];
  bool _starting = false;
  bool _uploadingPhotos = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _starting = true);
    try {
      await ref.read(managerMaintenanceRepositoryProvider).updateStatus(
            id: widget.requestId,
            status: MaintenanceStatus.EN_COURS,
          );
      ref.invalidate(managerMaintenanceDetailProvider(widget.requestId));
      ref.read(assignedMaintenanceProvider.notifier).refresh();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<void> _uploadBeforePhotos() async {
    if (_beforePhotos.isEmpty) return;
    setState(() => _uploadingPhotos = true);
    try {
      await ref.read(managerMaintenanceRepositoryProvider).uploadAttachments(
            requestId: widget.requestId,
            files: _beforePhotos,
            phase: AttachmentPhase.AVANT,
          );
      ref.invalidate(managerMaintenanceDetailProvider(widget.requestId));
      if (!mounted) return;
      setState(() => _beforePhotos = []);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Photos "avant" envoyées.')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploadingPhotos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(managerMaintenanceDetailProvider(widget.requestId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Intervention')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(managerMaintenanceDetailProvider(widget.requestId)),
        ),
        data: (request) {
          final property = request.property;
          final tenant = request.tenant;
          return RefreshIndicator(
            onRefresh: () => ref.refresh(managerMaintenanceDetailProvider(widget.requestId).future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(request.category, style: theme.textTheme.titleLarge)),
                          MaintenanceStatusChip(status: request.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      MaintenancePriorityChip(priority: request.priority),
                      const SizedBox(height: 12),
                      Text(request.description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Bien', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(property?.title ?? 'Bien inconnu', style: theme.textTheme.titleSmall),
                            if (property?.addressLine != null)
                              Text('${property!.addressLine}, ${property.city ?? ''}',
                                  style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (property?.latitude != null && property?.longitude != null)
                        IconButton(
                          tooltip: 'Ouvrir dans une application de cartes',
                          icon: const Icon(Icons.map_outlined),
                          onPressed: () => launchUrl(
                            Uri.parse('geo:${property!.latitude},${property.longitude}?q=${property.latitude},${property.longitude}(${Uri.encodeComponent(property.title)})'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Locataire', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tenant?.fullName ?? 'Non renseigné', style: theme.textTheme.titleSmall),
                            if (tenant?.phone != null) Text(tenant!.phone!, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (tenant?.phone != null)
                        IconButton(
                          icon: const Icon(Icons.call_outlined),
                          onPressed: () => launchUrl(Uri(scheme: 'tel', path: tenant!.phone)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (request.status == MaintenanceStatus.ASSIGNEE)
                  FilledButton.icon(
                    onPressed: _starting ? null : _start,
                    icon: _starting
                        ? const SizedBox(
                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_circle_outline),
                    label: const Text("Démarrer l'intervention"),
                  ),
                if (request.status == MaintenanceStatus.EN_COURS) ...[
                  Text('Photos avant intervention', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  PhotoPickerWidget(
                    photos: _beforePhotos,
                    onChanged: (photos) => setState(() => _beforePhotos = photos),
                    label: 'Photos "avant"',
                  ),
                  if (_beforePhotos.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _uploadingPhotos ? null : _uploadBeforePhotos,
                      icon: _uploadingPhotos
                          ? const SizedBox(
                              width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Envoyer les photos'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes techniques (aide-mémoire local)',
                      helperText: "Ces notes ne sont pas envoyées au serveur (l'API ne stocke pas de notes techniques) - utilisez-les comme aide-mémoire avant de finaliser.",
                      helperMaxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.managerAssignedCompletePath(request.id)),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Terminer l'intervention"),
                  ),
                ],
                if (request.attachments != null && request.attachments!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Photos existantes', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in request.attachments!)
                        CachedThumb(
                          relativeUrl: a.url,
                          width: 72,
                          height: 72,
                          borderRadius: BorderRadius.circular(8),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
