import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/maintenance_model.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cached_thumb.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../providers/tenant_providers.dart';

class MaintenanceDetailScreen extends ConsumerWidget {
  const MaintenanceDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(maintenanceDetailProvider(requestId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Demande de maintenance')),
      body: detailAsync.when(
        loading: () => const SkeletonList(),
        error: (error, stackTrace) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(maintenanceDetailProvider(requestId)),
        ),
        data: (request) => RefreshIndicator(
          onRefresh: () => ref.refresh(maintenanceDetailProvider(requestId).future),
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
                        MaintenancePriorityChip(priority: request.priority),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(request.description, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text(
                      'Créée le ${Formatters.date(request.createdAt)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Suivi', style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              _StatusTimeline(current: request.status),
              if (request.attachments != null && request.attachments!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Photos', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                _AttachmentsGrid(attachments: request.attachments!),
              ],
              if (request.estimatedCost != null || request.actualCost != null) ...[
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (request.estimatedCost != null)
                        _Row(label: 'Coût estimé', value: Formatters.amount(request.estimatedCost!)),
                      if (request.actualCost != null)
                        _Row(label: 'Coût réel', value: Formatters.amount(request.actualCost!)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.current});

  final MaintenanceStatus current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = MaintenanceStatus.values;
    final currentIndex = current.stepIndex;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= currentIndex
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: i <= currentIndex
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  if (i != steps.length - 1)
                    Container(
                      width: 2,
                      height: 32,
                      color: i < currentIndex
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  steps[i].label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: i == currentIndex ? FontWeight.bold : FontWeight.normal,
                    color: i <= currentIndex
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _AttachmentsGrid extends StatelessWidget {
  const _AttachmentsGrid({required this.attachments});

  final List<MaintenanceAttachmentModel> attachments;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        return GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: CachedThumb(
                relativeUrl: attachment.url,
                fit: BoxFit.contain,
              ),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedThumb(
                relativeUrl: attachment.url,
                borderRadius: BorderRadius.circular(10),
              ),
              Positioned(
                left: 4,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    attachment.phase == 'AVANT' ? 'Avant' : 'Après',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
