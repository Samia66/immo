import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// A single overflow-navigation entry offered by [showAccountSheet] below the
/// account header (e.g. the manager module's "Locataires"/"Maintenance"/
/// "Notifications"/"Profil" - spec §8/§52: sections not important enough to
/// be a primary bottom-nav tab, but still reachable).
class AccountSheetMenuItem {
  const AccountSheetMenuItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Bottom sheet showing basic account info + logout, used from the agent and
/// manager home screens (which - per the spec's screen list - don't have a
/// dedicated primary nav entry for every section). [menuItems] renders as an
/// extra navigation list above the logout button - the manager module's
/// overflow menu (spec §8/§52).
void showAccountSheet(
  BuildContext context,
  WidgetRef ref, {
  required String roleLabel,
  List<AccountSheetMenuItem> menuItems = const [],
}) {
  final user = ref.read(authNotifierProvider).user;
  showModalBottomSheet(
    context: context,
    builder: (context) =>
        _AccountSheetContent(user: user, roleLabel: roleLabel, menuItems: menuItems),
  );
}

class _AccountSheetContent extends ConsumerWidget {
  const _AccountSheetContent({required this.user, required this.roleLabel, required this.menuItems});

  final UserModel? user;
  final String roleLabel;
  final List<AccountSheetMenuItem> menuItems;

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
            if (menuItems.isNotEmpty) ...[
              const Divider(height: 28),
              for (final item in menuItems)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onTap();
                  },
                ),
            ],
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
