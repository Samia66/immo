import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/invitation_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/auth_provider.dart';

/// Second step of the tenant self-activation flow: shows the invitation's
/// read-only preview, lets the tenant request + enter an OTP for their
/// contact (phone or email), then completes the account (password + name)
/// and submits `POST /invitations/:code/activate`, logging them straight in.
class ActivateAccountScreen extends ConsumerStatefulWidget {
  const ActivateAccountScreen({super.key, required this.code, required this.preview});

  final String code;
  final InvitationPreviewModel preview;

  @override
  ConsumerState<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends ConsumerState<ActivateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _otpRequested = false;
  bool _requestingOtp = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _contactController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    final contact = _contactController.text.trim();
    if (contact.isEmpty) {
      setState(() => _error = 'Veuillez saisir votre téléphone ou email.');
      return;
    }
    setState(() {
      _requestingOtp = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).requestOtp(
            contact: contact,
            purpose: 'ACTIVATE_TENANT',
          );
      if (!mounted) return;
      setState(() => _otpRequested = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un code de vérification a été envoyé.')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Une erreur est survenue.');
    } finally {
      if (mounted) setState(() => _requestingOtp = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final user = await ref.read(invitationRepositoryProvider).activate(
            code: widget.code,
            contact: _contactController.text.trim(),
            otpCode: _otpController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          );
      if (!mounted) return;
      // The router's redirect logic takes it from here based on the applied
      // auth state (role-based home route).
      ref.read(authNotifierProvider.notifier).applyLoggedInUser(user);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = widget.preview;

    return Scaffold(
      appBar: AppBar(title: const Text('Activer mon compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description_outlined, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Contrat ${preview.leaseReference}',
                                  style: theme.textTheme.titleMedium),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${preview.unitLabel} — ${preview.propertyTitle}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preview.organizationName,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _contactController,
                          enabled: !_otpRequested,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Téléphone ou email',
                            prefixIcon: Icon(Icons.contact_mail_outlined),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty)
                              ? 'Ce champ est requis'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        if (!_otpRequested)
                          OutlinedButton.icon(
                            onPressed: _requestingOtp ? null : _requestOtp,
                            icon: _requestingOtp
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.sms_outlined),
                            label: const Text('Recevoir le code'),
                          )
                        else ...[
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              labelText: 'Code de vérification (6 chiffres)',
                              prefixIcon: Icon(Icons.pin_outlined),
                              counterText: '',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length != 6) {
                                return 'Saisissez le code à 6 chiffres';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _requestingOtp ? null : _requestOtp,
                              child: const Text('Renvoyer le code'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty) ? 'Prénom requis' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty) ? 'Nom requis' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return 'Le mot de passe doit contenir au moins 8 caractères';
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
                                : const Text('Activer mon compte'),
                          ),
                        ],
                      ],
                    ),
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
