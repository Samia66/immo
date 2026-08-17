import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/owner_invitation_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../providers/manager_owner_providers.dart';

/// "+ Inviter" - `POST /owners/invitations`. On success, shows the generated
/// code + share message with a copy-to-clipboard action (no `share_plus`
/// dependency in this project yet, so a plain copy + SnackBar confirmation is
/// the simplest correct option here).
class NewOwnerInvitationScreen extends ConsumerStatefulWidget {
  const NewOwnerInvitationScreen({super.key});

  @override
  ConsumerState<NewOwnerInvitationScreen> createState() => _NewOwnerInvitationScreenState();
}

class _NewOwnerInvitationScreenState extends ConsumerState<NewOwnerInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _submitting = false;
  String? _error;
  OwnerInvitationModel? _created;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final invitation = await ref.read(managerOwnerRepositoryProvider).inviteOwner(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;
      ref.invalidate(managerHasOwnersProvider);
      setState(() => _created = invitation);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Une erreur est survenue.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Copié dans le presse-papiers.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final created = _created;

    return Scaffold(
      appBar: AppBar(title: const Text('Inviter un propriétaire')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: created != null
                  ? _InvitationResult(invitation: created, onCopy: _copy)
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Un code sera généré et valable 7 jours.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.colorScheme.outline),
                          ),
                          const SizedBox(height: 20),
                          if (_error != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_error!,
                                  style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextFormField(
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(labelText: 'Prénom'),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty) ? 'Requis' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(labelText: 'Nom'),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty) ? 'Requis' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email (facultatif)',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Téléphone (facultatif)',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _submitting ? null : _submit,
                            child: _submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  )
                                : const Text("Envoyer l'invitation"),
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

class _InvitationResult extends StatelessWidget {
  const _InvitationResult({required this.invitation, required this.onCopy});

  final OwnerInvitationModel invitation;
  final Future<void> Function(String text) onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = invitation.shareMessage ??
        '${invitation.firstName} ${invitation.lastName} vous invite à rejoindre ImmoSaaS en tant que propriétaire. Code : ${invitation.code}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.check_circle_outline, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 12),
        Text('Invitation envoyée', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(
          'Partagez ce code avec ${invitation.firstName} ${invitation.lastName}.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Code', style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      invitation.code,
                      style: theme.textTheme.headlineMedium?.copyWith(letterSpacing: 1.5),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined),
                    tooltip: 'Copier le code',
                    onPressed: () => onCopy(invitation.code),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text('Message à partager', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(message, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => onCopy(message),
                icon: const Icon(Icons.copy_outlined),
                label: const Text('Copier le message'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Terminer'),
        ),
      ],
    );
  }
}
