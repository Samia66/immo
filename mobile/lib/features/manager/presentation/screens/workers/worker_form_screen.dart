import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/paginated_result.dart';
import '../../../../../core/models/property_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_skeleton.dart';
import '../../../../agent/presentation/providers/agent_providers.dart' show propertiesRepositoryProvider;
import '../../providers/manager_worker_providers.dart';

/// Create/edit form for a worker/contractor: `workerId` null means create,
/// otherwise this loads and pre-fills the existing worker and offers a
/// delete action.
class WorkerFormScreen extends ConsumerStatefulWidget {
  const WorkerFormScreen({super.key, this.workerId});

  final String? workerId;

  @override
  ConsumerState<WorkerFormScreen> createState() => _WorkerFormScreenState();
}

class _WorkerFormScreenState extends ConsumerState<WorkerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _tradeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  PropertyModel? _property;
  bool _isActive = true;
  bool _submitting = false;
  bool _deleting = false;
  bool _prefilled = false;
  String? _error;

  bool get _isEditing => widget.workerId != null;

  @override
  void dispose() {
    _fullNameController.dispose();
    _tradeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickProperty() async {
    final selected = await showModalBottomSheet<PropertyModel?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _PropertyPickerSheet(),
    );
    if (selected != _property) setState(() => _property = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final data = <String, dynamic>{
      'fullName': _fullNameController.text.trim(),
      'trade': _tradeController.text.trim(),
      'phone': _phoneController.text.trim(),
      if (_emailController.text.trim().isNotEmpty) 'email': _emailController.text.trim(),
      if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
      'propertyId': _property?.id,
      'isActive': _isActive,
    };

    try {
      final repo = ref.read(managerWorkerRepositoryProvider);
      if (_isEditing) {
        await repo.update(widget.workerId!, data);
        ref.invalidate(managerWorkerDetailProvider(widget.workerId!));
      } else {
        await repo.create(data);
      }
      ref.read(managerWorkersListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
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

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cet ouvrier ?'),
        content: const Text('Il ne sera plus visible ni par vous, ni par vos locataires.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    try {
      await ref.read(managerWorkerRepositoryProvider).remove(widget.workerId!);
      ref.read(managerWorkersListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  /// Fire-and-forget: fills the simple text fields synchronously, then - if
  /// the worker is tied to a property - fetches that property's own detail
  /// (all we have on the worker is its bare id) so the picker can show its
  /// title instead of just "Tous les biens".
  void _prefill(dynamic worker) {
    if (_prefilled) return;
    _prefilled = true;
    _fullNameController.text = worker.fullName;
    _tradeController.text = worker.trade;
    _phoneController.text = worker.phone;
    _emailController.text = worker.email ?? '';
    _notesController.text = worker.notes ?? '';
    _isActive = worker.isActive;

    final propertyId = worker.propertyId as String?;
    if (propertyId != null) {
      ref.read(propertiesRepositoryProvider).getDetail(propertyId).then((property) {
        if (mounted) setState(() => _property = property);
      }).catchError((_) {
        // Best-effort - leave the picker showing "Tous les biens" if this fails.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync =
        _isEditing ? ref.watch(managerWorkerDetailProvider(widget.workerId!)) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Modifier l'ouvrier" : 'Nouvel ouvrier'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: _deleting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.delete_outline),
              onPressed: _deleting ? null : _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: detailAsync == null
            ? _buildForm(context)
            : detailAsync.when(
                loading: () => const SkeletonList(),
                error: (error, stackTrace) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(managerWorkerDetailProvider(widget.workerId!)),
                ),
                data: (worker) {
                  _prefill(worker);
                  return _buildForm(context);
                },
              ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _fullNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Nom complet'),
            validator: (value) => (value == null || value.trim().isEmpty) ? 'Requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tradeController,
            decoration: const InputDecoration(
              labelText: 'Métier',
              hintText: 'ex. Plomberie, Électricité, Serrurerie...',
            ),
            validator: (value) => (value == null || value.trim().isEmpty) ? 'Requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Téléphone'),
            validator: (value) => (value == null || value.trim().isEmpty) ? 'Requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email (facultatif)'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes (facultatif)', alignLabelWithHint: true),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickProperty,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Bien concerné',
                prefixIcon: Icon(Icons.apartment_outlined),
                helperText: 'Facultatif - laissez vide pour le rendre visible sur tous vos biens.',
                helperMaxLines: 2,
              ),
              child: Text(_property?.title ?? 'Tous les biens'),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Actif'),
            subtitle: const Text('Visible par les locataires quand activé.'),
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                : Text(_isEditing ? 'Enregistrer' : "Ajouter l'ouvrier"),
          ),
        ],
      ),
    );
  }
}

class _PropertyPickerSheet extends ConsumerStatefulWidget {
  const _PropertyPickerSheet();

  @override
  ConsumerState<_PropertyPickerSheet> createState() => _PropertyPickerSheetState();
}

class _PropertyPickerSheetState extends ConsumerState<_PropertyPickerSheet> {
  late Future<PaginatedResult<PropertyModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(propertiesRepositoryProvider).list(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        child: FutureBuilder<PaginatedResult<PropertyModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            final properties = snapshot.data?.data ?? const <PropertyModel>[];
            return ListView(
              controller: scrollController,
              children: [
                ListTile(
                  leading: const Icon(Icons.public_outlined),
                  title: const Text('Tous les biens'),
                  onTap: () => Navigator.of(context).pop(),
                ),
                for (final property in properties)
                  ListTile(
                    leading: const Icon(Icons.apartment_outlined),
                    title: Text(property.title),
                    onTap: () => Navigator.of(context).pop(property),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
