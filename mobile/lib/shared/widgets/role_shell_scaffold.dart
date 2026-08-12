import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellTab {
  const ShellTab({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount,
  });

  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? badgeCount;
}

/// Bottom-navigation shell shared by the tenant/agent/manager role sections.
/// Each role's ShellRoute builder wraps its nested navigator with this,
/// switching tabs via `context.go` (so each tab keeps its own route stack
/// root) while [child] renders whichever nested route is currently active.
class RoleShellScaffold extends StatelessWidget {
  const RoleShellScaffold({
    super.key,
    required this.child,
    required this.tabs,
    required this.currentPath,
  });

  final Widget child;
  final List<ShellTab> tabs;
  final String currentPath;

  int get _currentIndex {
    final index = tabs.indexWhere((t) => currentPath.startsWith(t.path));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => context.go(tabs[index].path),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: tab.badgeCount != null && tab.badgeCount! > 0
                  ? Badge(label: Text('${tab.badgeCount}'), child: Icon(tab.icon))
                  : Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
