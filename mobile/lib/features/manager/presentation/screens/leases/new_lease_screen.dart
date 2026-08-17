import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/models/lease_model.dart';
import '../../../../../core/models/paginated_result.dart';
import '../../../../../core/models/property_model.dart';
import '../../../../../core/models/tenant_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../agent/presentation/providers/agent_providers.dart' show propertiesRepositoryProvider;
import '../../providers/manager_lease_providers.dart';
import '../../providers/manager_tenant_providers.dart';

/// "+ Nouveau contrat" wizard: pick a property → pick one of its `DISPONIBLE`
/// units → pick (or create) a tenant → fill in the contract terms →
/// `POST /leases`. Only properties/units the manager can already see are
/// ever offered (spec: `GET /properties` is already scoped, so no extra
/// eligibility check is needed client-side beyond that).
class NewLeaseScreen extends ConsumerStatefulWidget {
  const NewLeaseScreen({super.key});

  @override
  ConsumerState<NewLeaseScreen> createState() => _NewLeaseScreenState();
}

class _NewLeaseScreenState extends ConsumerState<NewLeaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _indexationController = TextEditingController();
  final _rentDueDayController = TextEditingController(text: '5');

  PropertyModel? _property;
  PropertyUnitModel? _unit;
  TenantModel? _tenant;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  PaymentFrequency _frequency = PaymentFrequency.MENSUEL;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _rentController.dispose();
    _depositController.dispose();
    _indexationController.dispose();
    _rentDueDayController.dispose();
    super.dispose();
  }

  Future<void> _pickProperty() async {
    final selected = await showModalBottomSheet<PropertyModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _PropertyPickerSheet(),
    );
    if (selected != null) {
      setState(() {
        _property = selected;
        _unit = null;
      });
    }
  }

  Future<void> _pickUnit() async {
    final property = _property;
    if (property == null) return;
    final available = (property.units ?? const <PropertyUnitModel>[])
        .where((u) => u.status == PropertyStatus.DISPONIBLE)
        .toList();
    final selected = await showModalBottomSheet<PropertyUnitModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _UnitPickerSheet(units: available),
    );
    if (selected != null) {
      setState(() {
        _unit = selected;
        _rentController.text = selected.monthlyRent.toString();
      });
    }
  }

  Future<void> _pickTenant() async {
    final selected = await showModalBottomSheet<TenantModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _TenantPickerSheet(),
    );
    if (selected != null) setState(() => _tenant = selected);
  }

  Future<void> _createTenantInline() async {
    final created = await context.push<TenantModel>(AppRoutes.managerTenantNew);
    if (created != null) setState(() => _tenant = created);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : (_endDate ?? _startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_unit == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Veuillez choisir un lot disponible.')));
      return;
    }
    if (_tenant == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Veuillez choisir un locataire.')));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });

    final indexationRate = num.tryParse(_indexationController.text.trim());
    final data = <String, dynamic>{
      'propertyUnitId': _unit!.id,
      'tenantId': _tenant!.id,
      'startDate': _startDate.toIso8601String().split('T').first,
      if (_endDate != null) 'endDate': _endDate!.toIso8601String().split('T').first,
      'rentAmount': num.parse(_rentController.text.trim()),
      'depositAmount': num.parse(_depositController.text.trim()),
      'paymentFrequency': _frequency.name,
      'rentDueDay': int.parse(_rentDueDayController.text.trim()),
      'indexationRate': ?indexationRate,
    };

    try {
      final created = await ref.read(managerLeaseRepositoryProvider).create(data);
      if (!mounted) return;
      ref.read(managerLeasesListProvider.notifier).refresh();
      context.pushReplacement(AppRoutes.managerLeaseDetailPath(created.id));
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
      appBar: AppBar(title: const Text('Nouveau contrat')),
      body: SafeArea(
        child: Form(
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
              Text('Bien', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              _PickerTile(
                icon: Icons.apartment_outlined,
                label: _property?.title ?? 'Choisir un bien',
                onTap: _pickProperty,
              ),
              const SizedBox(height: 16),
              Text('Lot', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              _PickerTile(
                icon: Icons.meeting_room_outlined,
                label: _unit != null
                    ? '${_unit!.displayLabel} · ${Formatters.amount(_unit!.monthlyRent)}'
                    : (_property == null ? 'Choisissez un bien' : 'Choisir un lot disponible'),
                onTap: _property == null ? null : _pickUnit,
              ),
              const SizedBox(height: 16),
              Text('Locataire', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              _PickerTile(
                icon: Icons.person_outline,
                label: _tenant?.fullName ?? 'Choisir un locataire',
                onTap: _pickTenant,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _createTenantInline,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: const Text('Créer un nouveau locataire'),
                ),
              ),
              const SizedBox(height: 16),
              Text('Conditions du contrat', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DatePickerTile(
                      label: 'Début',
                      date: _startDate,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerTile(
                      label: 'Fin (facultatif)',
                      date: _endDate,
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Loyer mensuel'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Loyer requis';
                  return num.tryParse(value.trim()) == null ? 'Montant invalide' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _depositController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Dépôt de garantie'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Dépôt requis';
                  return num.tryParse(value.trim()) == null ? 'Montant invalide' : null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentFrequency>(
                initialValue: _frequency,
                decoration: const InputDecoration(labelText: 'Fréquence de paiement'),
                items: [
                  for (final f in PaymentFrequency.values)
                    DropdownMenuItem(value: f, child: Text(f.label)),
                ],
                onChanged: (value) => setState(() => _frequency = value ?? _frequency),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rentDueDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jour d\'échéance du loyer (1-28)',
                  helperText: 'Ex. 5 = le loyer est dû le 5 de chaque mois.',
                ),
                validator: (value) {
                  final day = int.tryParse((value ?? '').trim());
                  if (day == null || day < 1 || day > 28) return 'Jour invalide (1 à 28)';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _indexationController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Taux d'indexation % (facultatif)"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  return num.tryParse(value.trim()) == null ? 'Valeur invalide' : null;
                },
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Text('Créer le contrat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          enabled: onTap != null,
        ),
        child: Text(label, style: onTap == null ? TextStyle(color: theme.colorScheme.outline) : null),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.event_outlined)),
        child: Text(date != null ? Formatters.date(date) : '-'),
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
  final _controller = TextEditingController();
  Timer? _debounce;
  late Future<PaginatedResult<PropertyModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(propertiesRepositoryProvider).list(limit: 50);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _future = ref.read(propertiesRepositoryProvider).list(limit: 50, search: value, unitStatus: null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Rechercher un bien...',
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
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
                  if (properties.isEmpty) {
                    return const Center(child: Text('Aucun bien trouvé.'));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      final availableCount = property.availableUnitsCount;
                      return ListTile(
                        leading: const Icon(Icons.apartment_outlined),
                        title: Text(property.title),
                        subtitle: Text('$availableCount lot(s) disponible(s)'),
                        enabled: availableCount > 0,
                        onTap: availableCount > 0 ? () => Navigator.of(context).pop(property) : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitPickerSheet extends StatelessWidget {
  const _UnitPickerSheet({required this.units});

  final List<PropertyUnitModel> units;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        child: units.isEmpty
            ? const Center(child: Text('Aucun lot disponible dans ce bien.'))
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: units.length,
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    onTap: () => Navigator.of(context).pop(unit),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.meeting_room_outlined),
                      title: Text(unit.displayLabel),
                      subtitle: Text(Formatters.amount(unit.monthlyRent)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _TenantPickerSheet extends ConsumerStatefulWidget {
  const _TenantPickerSheet();

  @override
  ConsumerState<_TenantPickerSheet> createState() => _TenantPickerSheetState();
}

class _TenantPickerSheetState extends ConsumerState<_TenantPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  late Future<PaginatedResult<TenantModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(managerTenantRepositoryProvider).list(limit: 50);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _future = ref.read(managerTenantRepositoryProvider).list(limit: 50, search: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Rechercher un locataire...',
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: FutureBuilder<PaginatedResult<TenantModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  final tenants = snapshot.data?.data ?? const <TenantModel>[];
                  if (tenants.isEmpty) {
                    return const Center(child: Text('Aucun locataire trouvé.'));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: tenants.length,
                    itemBuilder: (context, index) {
                      final tenant = tenants[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                              tenant.fullName.isNotEmpty ? tenant.fullName[0].toUpperCase() : '?'),
                        ),
                        title: Text(tenant.fullName),
                        subtitle: Text(tenant.phone),
                        onTap: () => Navigator.of(context).pop(tenant),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
