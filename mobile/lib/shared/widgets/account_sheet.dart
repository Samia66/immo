import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Bottom sheet showing basic account info + logout, used from the agent and
/// manager home screens (which - per the spec's screen list - don't have a
/// dedicated profile screen the way the tenant flow does).
void showAccountSheet(BuildContext context, WidgetRef ref, {required String roleLabel}) {
  final user = ref.read(authNotifierProvider).user;
  showModalBottomSheet(
    context: context,
    builder: (context) => _AccountSheetContent(user: user, roleLabel: roleLabel),
  );
}

class _AccountSheetContent extends ConsumerWidget {
  const _AccountSheetContent({required this.user, required this.roleLabel});

  final UserModel? user;
  final String roleLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    user != null && user!.firstName.isNotEmpty
                        ? user!.firstName[0].toUpperCase()
                        : '?',
                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.fullName ?? '', style: theme.textTheme.titleMedium),
                      Text(user?.email ?? '',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline)),
                      Text(roleLabel,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authNotifierProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
