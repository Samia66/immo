import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';

/// First screen shown to a visitor with no stored session (the splash
/// screen's bootstrap already ruled that out before the router lands here).
/// Replaces going straight to [LoginScreen] - self-registration (spec §5.1)
/// is now a real, first-class entry point, not just an admin-provisioned
/// account.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.apartment_rounded, size: 72, color: theme.colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'ImmoSaaS',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gérez vos biens, propriétaires et locataires depuis votre mobile.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Créer un compte'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Se connecter'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.invitationEntry),
                    child: const Text("J'ai reçu une invitation"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
