import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/tenant_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../providers/manager_tenant_providers.dart';

/// "+ Ajouter" - `POST /tenants`. `CreateTenantDto` (verified against the
/// real backend source) only requires `fullName`/`phone`; `email`,
/// `profession`, `employer` and `monthlyIncome` are optional.
///
/// Pops with the created [TenantModel] on success, so this screen doubles as
/// the "create a tenant inline" step of [NewLeaseScreen]'s wizard when the
/// manager has no tenant yet, in addition to being reachable from
/// [ManagerTenantsScreen]'s FAB.
class NewTenantScreen extends ConsumerStatefulWidget {
  const NewTenantScreen({super.key});

  @override
  ConsumerState<NewTenantScreen> createState() => _NewTenantScreenState();
}

class _NewTenantScreenState extends ConsumerState<NewTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _professionController = TextEditingController();
  final _employerController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _professionController.dispose();
    _employerController.dispose();
    _monthlyIncomeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });

    final monthlyIncome = num.tryParse(_monthlyIncomeController.text.trim());
    final data = <String, dynamic>{
      'fullName': _fullNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      if (_emailController.text.trim().isNotEmpty) 'email': _emailController.text.trim(),
      if (_professionController.text.trim().isNotEmpty)
        'profession': _professionController.text.trim(),
      if (_employerController.text.trim().isNotEmpty)
        'employer': _employerController.text.trim(),
      'monthlyIncome': ?monthlyIncome,
    };

    try {
      final created = await ref.read(managerTenantRepositoryProvider).create(data);
      if (!mounted) return;
      ref.read(managerTenantsListProvider.notifier).refresh();
      Navigator.of(context).pop(created);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un locataire')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nom complet'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Nom requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Téléphone'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Téléphone requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email (facultatif)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _professionController,
                      decoration: const InputDecoration(labelText: 'Profession (facultatif)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _employerController,
                      decoration: const InputDecoration(labelText: 'Employeur (facultatif)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _monthlyIncomeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Revenu mensuel (facultatif)'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        return num.tryParse(value.trim()) == null ? 'Montant invalide' : null;
                      },
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
                          : const Text('Ajouter le locataire'),
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
