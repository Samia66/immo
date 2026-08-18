import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/worker_model.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import '../providers/tenant_providers.dart';

/// Read-only worker/contractor address book for the tenant: `GET /workers/me`
/// - whoever the manager put here for the tenant's own property (plus
/// "general" ones with no property), so there's someone to call in case of
/// a problem without having to first file a maintenance request.
class WorkersScreen extends ConsumerWidget {
  const WorkersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(myWorkersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ouvriers utiles')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myWorkersProvider.future),
        child: workersAsync.when(
          loading: () => const SkeletonList(),
          error: (error, stackTrace) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(myWorkersProvider),
          ),
          data: (workers) {
            if (workers.isEmpty) {
              return const EmptyStateView(
                icon: Icons.engineering_outlined,
                title: 'Aucun ouvrier renseigné',
                message: "Votre gestionnaire n'a pas encore ajouté de contact pour votre bien.",
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _WorkerCard(worker: workers[index]),
            );
          },
        ),
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  const _WorkerCard({required this.worker});

  final WorkerModel worker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.build_outlined, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker.fullName, style: theme.textTheme.titleSmall),
                Text(worker.trade,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: worker.phone)),
          ),
        ],
      ),
    );
  }
}
