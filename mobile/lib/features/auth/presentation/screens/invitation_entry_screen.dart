import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';

enum _InvitationKind { tenant, owner }

/// Entry point of the pre-auth self-activation flow, reachable from
/// [WelcomeScreen]/[LoginScreen] via "J'ai reçu une invitation". Generalized
/// to cover both invitation types the backend now issues (spec §5.2/§5.3):
/// a `TenantInvitation` (tied to a lease) and an `OwnerInvitation` (tied to a
/// manager). Since both codes look identical (`IMMO-XXXXX`) and there is no
/// single "detect the type" endpoint, the user picks which one they hold via
/// a segmented choice up front, so the right preview/accept endpoints are
/// called directly instead of guessing-and-retrying on a 404.
class InvitationEntryScreen extends ConsumerStatefulWidget {
  const InvitationEntryScreen({super.key});

  @override
  ConsumerState<InvitationEntryScreen> createState() => _InvitationEntryScreenState();
}

class _InvitationEntryScreenState extends ConsumerState<InvitationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  _InvitationKind _kind = _InvitationKind.tenant;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    final code = _codeController.text.trim();
    try {
      if (_kind == _InvitationKind.tenant) {
        final preview = await ref.read(invitationRepositoryProvider).preview(code);
        if (!mounted) return;
        context.push(AppRoutes.activateAccount, extra: {'code': code, 'preview': preview});
      } else {
        final preview = await ref.read(ownerInvitationRepositoryProvider).preview(code);
        if (!mounted) return;
        context.push(AppRoutes.ownerActivateAccount, extra: {'code': code, 'preview': preview});
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      final isInvalid = e.statusCode == 404 || e.statusCode == 410;
      setState(() {
        _error = isInvalid ? 'Code invalide ou expiré.' : e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Une erreur est survenue.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Activer mon compte')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.mail_outline_rounded, size: 56, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      "J'ai reçu une invitation",
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Indiquez qui vous êtes puis saisissez le code reçu pour activer votre compte.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SegmentedButton<_InvitationKind>(
                      segments: const [
                        ButtonSegment(
                          value: _InvitationKind.tenant,
                          label: Text('Je suis locataire'),
                          icon: Icon(Icons.person_outline),
                        ),
                        ButtonSegment(
                          value: _InvitationKind.owner,
                          label: Text('Je suis propriétaire'),
                          icon: Icon(Icons.villa_outlined),
                        ),
                      ],
                      selected: {_kind},
                      onSelectionChanged: (selection) =>
                          setState(() => _kind = selection.first),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error!,
                          style: TextStyle(color: theme.colorScheme.onErrorContainer),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        labelText: "Code d'invitation",
                        hintText: 'IMMO-XXXXX',
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Veuillez saisir votre code d'invitation";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Text('Continuer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
