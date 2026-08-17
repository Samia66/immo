import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/owner_model.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../providers/manager_owner_providers.dart';
import '../providers/manager_property_providers.dart';

/// Two-step wizard: step 1 creates the building (`Property`), step 2 - shown
/// immediately after, pre-populated with the just-created property's id -
/// creates its first leasable `PropertyUnit`, so a manager never ends up
/// with a brand-new, unit-less (and therefore unleasable) listing.
class NewPropertyScreen extends ConsumerStatefulWidget {
  const NewPropertyScreen({super.key});

  @override
  ConsumerState<NewPropertyScreen> createState() => _NewPropertyScreenState();
}

class _NewPropertyScreenState extends ConsumerState<NewPropertyScreen> {
  int _step = 0;
  PropertyModel? _createdProperty;

  @override
  Widget build(BuildContext context) {
    final hasOwnersAsync = ref.watch(managerHasOwnersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_step == 0 ? 'Nouveau bien' : 'Premier lot'),
      ),
      body: hasOwnersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: EmptyStateView(
              icon: Icons.error_outline,
              title: 'Impossible de vérifier vos propriétaires',
              message: error.toString(),
              action: OutlinedButton(
                onPressed: () => ref.invalidate(managerHasOwnersProvider),
                child: const Text('Réessayer'),
              ),
            ),
          ),
        ),
        data: (hasOwners) {
          if (!hasOwners) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.villa_outlined,
                  title: "Invitez d'abord un propriétaire",
                  message:
                      "Un bien doit appartenir à un propriétaire que vous gérez. Invitez-en un avant de créer votre premier bien.",
                  action: FilledButton.icon(
                    onPressed: () => context.pushReplacement(AppRoutes.managerOwnerInvite),
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    label: const Text('Inviter un propriétaire'),
                  ),
                ),
              ),
            );
          }
          return _step == 0
              ? _PropertyStep(
                  onCreated: (property) {
                    setState(() {
                      _createdProperty = property;
                      _step = 1;
                    });
                  },
                )
              : _UnitStep(
                  property: _createdProperty!,
                  onDone: (unitCreated) {
                    ref.read(managerPropertiesListProvider.notifier).refresh();
                    if (!mounted) return;
                    context
                        .pushReplacement(AppRoutes.managerPropertyDetailPath(_createdProperty!.id));
                  },
                );
        },
      ),
    );
  }
}

class _PropertyStep extends ConsumerStatefulWidget {
  const _PropertyStep({required this.onCreated});

  final void Function(PropertyModel property) onCreated;

  @override
  ConsumerState<_PropertyStep> createState() => _PropertyStepState();
}

class _PropertyStepState extends ConsumerState<_PropertyStep> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();

  PropertyType _type = PropertyType.APPARTEMENT;
  String? _ownerId;
  String? _ownerName;
  double? _latitude;
  double? _longitude;
  bool _taggingLocation = false;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _pickOwner() async {
    final selected = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _OwnerPickerSheet(),
    );
    if (selected != null) {
      setState(() {
        _ownerId = selected['id'];
        _ownerName = selected['name'];
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _taggingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission de localisation refusée.')),
        );
        return;
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le service de localisation est désactivé.')),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'obtenir la position actuelle.")),
      );
    } finally {
      if (mounted) setState(() => _taggingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ownerId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Veuillez sélectionner un propriétaire.')));
      return;
    }
    setState(() => _submitting = true);

    final data = <String, dynamic>{
      'title': _titleController.text.trim(),
      'type': _type.name,
      'addressLine': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'ownerId': _ownerId,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      if (_districtController.text.trim().isNotEmpty) 'district': _districtController.text.trim(),
      'latitude': ?_latitude,
      'longitude': ?_longitude,
    };

    try {
      final created = await ref.read(propertiesRepositoryProvider).create(data);
      if (!mounted) return;
      widget.onCreated(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Une erreur est survenue.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Étape 1/2 — Informations du bien (bâtiment/annonce)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Titre'),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Titre requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description (facultatif)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PropertyType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              for (final t in PropertyType.values)
                DropdownMenuItem(value: t, child: Text(t.label)),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Adresse'),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Adresse requise' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'Ville'),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Ville requise' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _districtController,
            decoration: const InputDecoration(labelText: 'Quartier (facultatif)'),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickOwner,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Propriétaire'),
              child: Text(_ownerName ?? 'Choisir un propriétaire'),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _taggingLocation ? null : _useCurrentLocation,
            icon: _taggingLocation
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(_latitude != null ? Icons.location_on : Icons.location_on_outlined),
            label: Text(_latitude != null
                ? 'Position ajoutée (${_latitude!.toStringAsFixed(3)}, ${_longitude!.toStringAsFixed(3)})'
                : 'Utiliser ma position actuelle (facultatif)'),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                : const Text('Continuer vers le premier lot'),
          ),
        ],
      ),
    );
  }
}

class _UnitStep extends ConsumerStatefulWidget {
  const _UnitStep({required this.property, required this.onDone});

  final PropertyModel property;
  final void Function(bool created) onDone;

  @override
  ConsumerState<_UnitStep> createState() => _UnitStepState();
}

class _UnitStepState extends ConsumerState<_UnitStep> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _labelController = TextEditingController();
  final _floorController = TextEditingController();
  final _roomsController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _rentController = TextEditingController();
  final _chargesController = TextEditingController();
  final _descriptionController = TextEditingController();

  PropertyType _type = PropertyType.APPARTEMENT;
  bool _submitting = false;

  @override
  void dispose() {
    _referenceController.dispose();
    _labelController.dispose();
    _floorController.dispose();
    _roomsController.dispose();
    _surfaceController.dispose();
    _rentController.dispose();
    _chargesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final rooms = int.tryParse(_roomsController.text.trim());
    final surface = double.tryParse(_surfaceController.text.trim());
    final charges = num.tryParse(_chargesController.text.trim());

    final data = <String, dynamic>{
      'reference': _referenceController.text.trim(),
      'type': _type.name,
      'monthlyRent': num.parse(_rentController.text.trim()),
      if (_labelController.text.trim().isNotEmpty) 'label': _labelController.text.trim(),
      if (_floorController.text.trim().isNotEmpty) 'floor': _floorController.text.trim(),
      'rooms': ?rooms,
      'surfaceM2': ?surface,
      'monthlyCharges': ?charges,
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
    };

    try {
      await ref.read(propertiesRepositoryProvider).createUnit(widget.property.id, data);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bien et premier lot créés avec succès.')));
      widget.onDone(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Une erreur est survenue.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Étape 2/2 — Premier lot de "${widget.property.title}"',
              style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            'Chaque bien doit avoir au moins un lot louable pour être exploitable.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _referenceController,
            decoration: const InputDecoration(
              labelText: 'Référence du lot',
              hintText: 'ex. A-203',
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Référence requise' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _labelController,
            decoration: const InputDecoration(
              labelText: 'Libellé (facultatif)',
              hintText: 'ex. Appartement A-203',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _floorController,
            decoration: const InputDecoration(labelText: 'Étage (facultatif)'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PropertyType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              for (final t in PropertyType.values)
                DropdownMenuItem(value: t, child: Text(t.label)),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _roomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Pièces (facultatif)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return int.tryParse(value.trim()) == null ? 'Nombre invalide' : null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _surfaceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Surface m² (facultatif)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return double.tryParse(value.trim()) == null ? 'Valeur invalide' : null;
                  },
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
            controller: _chargesController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Charges mensuelles (facultatif)'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              return num.tryParse(value.trim()) == null ? 'Montant invalide' : null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (facultatif)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                : const Text('Créer le lot'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _submitting ? null : () => widget.onDone(false),
            child: const Text('Passer cette étape (créer le lot plus tard)'),
          ),
        ],
      ),
    );
  }
}

/// Simple searchable owner picker: loads an initial page on open, then
/// re-queries `GET /owners?search=...` as the user types, debounced so we
/// don't fire a request per keystroke.
class _OwnerPickerSheet extends ConsumerStatefulWidget {
  const _OwnerPickerSheet();

  @override
  ConsumerState<_OwnerPickerSheet> createState() => _OwnerPickerSheetState();
}

class _OwnerPickerSheetState extends ConsumerState<_OwnerPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  late Future<PaginatedResult<OwnerModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(ownersRepositoryProvider).list();
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
        _future = ref.read(ownersRepositoryProvider).list(search: value);
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
                  hintText: 'Rechercher un propriétaire...',
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: FutureBuilder<PaginatedResult<OwnerModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  final owners = snapshot.data?.data ?? const <OwnerModel>[];
                  if (owners.isEmpty) {
                    return const Center(child: Text('Aucun propriétaire trouvé.'));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: owners.length,
                    itemBuilder: (context, index) {
                      final owner = owners[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                              owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?'),
                        ),
                        title: Text(owner.fullName),
                        subtitle: Text(owner.phone),
                        onTap: () => Navigator.of(context)
                            .pop({'id': owner.id, 'name': owner.fullName}),
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
